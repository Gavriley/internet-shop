class OrdersController < ApplicationController
	include CurrentCart
	before_action :set_cart, only: :create

	def create 
		@order = Order.new(order_params)
		@order.add_line_items_from_cart(@cart)
		@order.amount = @cart.total_price

		respond_to do |format|
			if @order.save
				make_current_order  
				
				Cart.destroy(session[:cart_id])
				session[:cart_id] = nil

				format.js { redirect_to root_path, notice: "Підтвердіть ваш заказ по e-mail" }
			else
				format.js 
				format.json { render json: @order.errors }
			end	
		end
	end	

	private
		def order_params
			params.require(:order).permit(:email, :name, :address)
		end	

		def make_current_order
			require 'liqpay'
			liqpay = Liqpay.new

			goods = Array.new

			@order.line_items.each do |line_item|  
				goods << { amount: line_item.product.price, count: line_item.count, unit: 'шт.', name: line_item.product.title }
			end	

			begin
				liqpay.api 'invoice/send', { email: @order.email, amount: @order.amount, currency: 'UAH',
				  order_id: @order.id, 
				  sandbox: 1,
				  goods: goods }
			rescue StandardError
				make_current_order
			end	     
		end	
end	