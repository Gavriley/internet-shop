class Admin::OrdersController < Admin::AdminController
	before_action :set_order, only: [:show]


	def index
		@title = 'Замовлення'
		@orders = Order.latest
	end

	def show 
		@title = "Замовлення №#{@order.id}"
		@order.set_off_check
	end	

	private

		def set_order
			@order = Order.find(params[:id])
		end	
end	