require 'liqpay'
require 'json'

class OrdersController < ApplicationController
	skip_before_filter :verify_authenticity_token

	include CurrentCart
	before_action :set_cart, only: :create

	def create 
		@order = Order.new(order_params)
		@order.add_line_items_from_cart(@cart)
		@order.amount = @cart.total_price

		respond_to do |format|
			if @order.save
				action_save
				format.js { redirect_to root_path, notice: "Підтвердіть ваш заказ по e-mail" }
			else
				format.js 
				format.json { render json: @order.errors }
			end	
		end
	end	

	def state
		order_json_params = JSON.parse(Base64.decode64(params["data"]))
		
		File.open('/home/darkness/insilico/log.txt', 'w') { |f| f << "Response state!!! #{order_json_params}" }
	end	

	private
		def order_params
			params.require(:order).permit(:email, :name, :address)
		end	

		def action_save 
			@order.process  
			Cart.destroy(session[:cart_id])
			session[:cart_id] = nil
			make_current_order
		end	

		def make_current_order
			goods = @order.line_items.map { |line_item| { amount: line_item.product.price, count: line_item.count, unit: 'шт.', name: line_item.product.title } }

			begin
				Liqpay.new.api 'invoice/send', { email: @order.email, amount: 0.01, currency: 'UAH', order_id: @order.id, goods: goods, server_url: state_orders_url }
			rescue StandardError
				make_current_order
			end	     
		end	
end	