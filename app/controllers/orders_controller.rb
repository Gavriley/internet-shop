require 'json'

class OrdersController < ApplicationController
	skip_before_filter :verify_authenticity_token

	include CurrentCart
	before_action :set_cart, only: :create
	before_action :set_order, only: :show

	def show
		raise ActiveRecord::RecordNotFound unless @order.process?
		@liqpay = Liqpay::Liqpay.new.cnb_form({ action: "pay", sandbox: 1, amount: 0.01, currency: "UAH", description: "Заказ №#{@order.id}", order_id: @order.id, version: "3", server_url: state_orders_url }).html_safe
	end	

	def create 
		@order = Order.new(order_params)
		@order.add_line_items_from_cart(@cart)
		@order.amount = @cart.total_price

		respond_to do |format|
			if @order.save
				handle_order
				format.js { redirect_to @order } 
			else
				format.js 
				format.json { render json: @order.errors }
			end	
		end
	end	

	def state
		order_json_params = JSON.parse(Base64.decode64(params["data"]))
		Order.find(order_json_params["order_id"]).try(order_json_params["status"])
		File.open('/home/darkness/insilico/log.txt', 'w') { |f| f << "Response state!!! #{order_json_params}" }
	end	

	private
		def order_params
			params.require(:order).permit(:email, :name, :address)
		end	

		def handle_order 
			Cart.destroy(session[:cart_id])
			session[:cart_id] = nil
			@order.process
		end	

		def set_order
			@order = Order.find(params[:id])
		end	

		# def make_current_order
		# 	goods = @order.line_items.map { |line_item| { amount: line_item.product.price, count: line_item.count, unit: 'шт.', name: line_item.product.title } }

		# 	begin
		# 		Liqpay.new.api 'invoice/send', { email: @order.email, amount: 0.01, currency: 'UAH', order_id: @order.id, goods: goods, server_url: state_orders_url }
		# 	rescue StandardError
		# 		make_current_order
		# 	end	     
		# end	
end	