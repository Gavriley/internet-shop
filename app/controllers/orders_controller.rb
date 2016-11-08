class OrdersController < ApplicationController
	
	def create 
		@order = Order.new(order_params)

		respond_to do |format|
			if @order.save
				make_current_order 
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

			@cart.line_items.each do |line_item|  
				goods << { amount: line_item.product.price, count: line_item.count, unit: 'шт.', name: line_item.product.title }
			end	

			begin
				liqpay.api 'invoice/send', { email: @order.email, amount: @cart.total_price, currency: 'UAH',
				  order_id: @order.id, 
				  sandbox: 1,
				  goods: goods }
			rescue StandardError
				make_current_order
			end	     
		end	
end	