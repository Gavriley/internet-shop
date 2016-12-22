require 'json'

class OrdersController < ApplicationController
	include CurrentCart

	load_and_authorize_resource

	skip_before_filter :verify_authenticity_token

	rescue_from AASM::InvalidTransition, with: -> { redirect_to root_path, notice: "Помилка при формуванні заказу" }

	before_action :set_order, only: [:show, :create_stripe]

	def show
		raise ActiveRecord::RecordNotFound if !@order.process?
		
		@liqpay = create_liqpay 
		@paypal = create_paypal	
	end	

	def create 
		@cart = Cart.find(cookies[:cart_id])
		@order = Order.new(order_params)

		respond_to do |format|
			if @order.valid?
				handle_order
				format.js { redirect_to @order } 
			else
				format.js 
			end	
		end
	end	

	def modal
		@order = Order.new
		render :modal, format: :js
	end	
	
	def liqpay_response
		order_json_params = JSON.parse(Base64.decode64(params["data"]))
		@order = Order.find(order_json_params["order_id"].delete("order_number_"))
		@order.last_error = order_json_params['err_description'] if order_json_params['err_description']
		
		@order.update_column(:pay_with, "Liqpay")

		case order_json_params["status"]
			when 'sandbox'
				@order.sandbox!
				Order.pay_logger.info("Заказ №#{@order.id} успішно оплачений")
			else 
				@order.failure!
				Order.pay_logger.error("В оплаті заказу №#{@order.id} сталася помилка #{@order.get_last_error}")
			end		

		# @order.try(order_json_params["status"] + "!") if @order.try("may_#{order_json_params["status"]}?")
		# File.open('/home/darkness/insilico/log.txt', 'w') { |f| f << order_json_params }
	end	

	def paypal_response 
		@order = Order.find(params[:invoice])
		@order.update_column(:pay_with, "PayPal")

		case params[:payment_status] 
			when 'Completed'
				@order.sandbox!
				Order.pay_logger.info("Заказ №#{@order.id} успішно оплачений")
			else
				@order.failure!
				Order.pay_logger.error("В оплаті заказу №#{@order.id} сталася помилка")
			end		
	end	

	def create_stripe
		begin
			customer = Stripe::Customer.create(
		    email: params[:stripeEmail],
		    source: params[:stripeToken]
		  )

		  charge = Stripe::Charge.create(
		    customer: customer.id,
		    amount: @order.amount * 100,
		    # amount: -1000,
		    description: "Заказ №#{@order.id}", 
		    currency: 'UAH'
		  )

		  @order.update_column(:pay_with, "Stripe")

		  @order.sandbox!

		  Order.pay_logger.info("Заказ №#{@order.id} успішно оплачений")

		  redirect_to root_path, notice: "Товари успішно оплачені"

	  rescue => error
	  	@order.last_error = error.message
	  	@order.failure!

	  	Order.pay_logger.error("В оплаті заказу №#{@order.id} сталася помилка #{@order.get_last_error}")
	  	
	  	redirect_to products_path, notice: "Помилка при оплаті"
	  end	
	end

	private
		def order_params
			params.require(:order).permit(:email, :name, :address)
		end	

		def handle_order 
			@order.add_line_items_from_cart(@cart)
			@order.amount = @cart.total_price

			@order.process
			@order.save

			destroy_cart

			Order.pay_logger.info("Новий заказ №#{@order.id} находиться в очікуванні")
		end	

		def set_order
			@order = Order.includes(line_items: :product).find(params[:id])
		end	

		def create_liqpay
			liqpay_params = { 
				action: "pay", 
				sandbox: 1, 
				amount: @order.amount, 
				# amount: -1000,
				currency: "UAH", 
				description: "Заказ №#{@order.id}", 
				order_id: "order_number_#{@order.id}", 
				version: "3", 
				server_url: liqpay_response_orders_url 
			}

			return Liqpay::Liqpay.new.cnb_form(liqpay_params).html_safe
		end	

		def create_paypal
			values = {
		    business: 'gavrileypetro-facilitator@gmail.com',
		    cmd: '_cart',
		    upload: 1,
		    notify_url: paypal_response_orders_url,
		    
		    # amount_6: -10000,
		    # item_name_6: 'Test Product',
		    # item_number_6: 9999,
		    # quantity_6: 1,

		    invoice: @order.id
		  }

		  @order.line_items.each_with_index do |item, index|
		    values.merge!({
		      "amount_#{index+1}" => item.product.price,
		      "item_name_#{index+1}" => item.product.title,
		      "item_number_#{index+1}" => item.id,
		      "quantity_#{index+1}" => item.count
		    })
		  end

		  return "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
		end	
end	