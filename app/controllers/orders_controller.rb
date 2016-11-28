require 'json'

class OrdersController < ApplicationController
	include CurrentCart
	skip_before_filter :verify_authenticity_token

	rescue_from AASM::InvalidTransition, with: -> { redirect_to root_path, notice: "Помилка при формуванні заказу" }

	before_action :set_cart, only: :create
	before_action :set_order, only: [:show, :create_stripe]

	def show
		raise ActiveRecord::RecordNotFound if !@order.process?
		File.open('/home/darkness/insilico/log.txt', 'w') { |f| f << Rails.application.secrets.stripe_publishable_key }
		@liqpay = create_liqpay 
		@paypal = create_paypal	
	end	

	def create 
		@order = Order.new(order_params)

		respond_to do |format|
			if @order.valid?
				handle_order
				format.html { redirect_to @order }
				format.js { redirect_to @order } 
			else
				format.html { render 'carts/index' }
				format.js 
				format.json { render json: @order.errors }
			end	
		end
	end	

	def liqpay_response
		order_json_params = JSON.parse(Base64.decode64(params["data"]))
		@order = Order.find(order_json_params["order_id"].delete("order_number_"))
		@order.last_error = order_json_params['err_description'] if order_json_params['err_description']
		@order.pay_with = "Liqpay"

		case order_json_params["status"]
			when 'sandbox'
				@order.sandbox!
			else 
				@order.failure!
			end		

		# @order.try(order_json_params["status"] + "!") if @order.try("may_#{order_json_params["status"]}?")
		# File.open('/home/darkness/insilico/log.txt', 'w') { |f| f << order_json_params }
	end	

	def paypal_response 
		params.permit!
		@order = Order.find(params[:invoice])
		@order.pay_with = "PayPal"

		case params[:payment_status] 
			when 'Completed'
				@order.sandbox!
			else 
				@order.failure!
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
		    description: "Заказ №#{@order.id}", 
		    currency: 'UAH'
		  )

		  @order.pay_with = "Stripe"

		  @order.sandbox!

		  redirect_to root_path, notice: "Товари успішно оплачені"

	  rescue Stripe::CardError
	  	redirect_to @order, notice: "Повторіть спробу"
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

			Cart.destroy(session[:cart_id])
			session[:cart_id] = nil
		end	

		def set_order
			@order = Order.includes(line_items: :product).find(params[:id])
		end	

		def create_liqpay
			liqpay_params = { 
				action: "pay", 
				sandbox: 1, 
				# amount: @order.amount, 
				amount: 0.01, 
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