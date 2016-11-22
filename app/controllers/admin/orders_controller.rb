class Admin::OrdersController < Admin::AdminController
	before_action :set_order, only: [:show]


	def index
		@title = 'Замовлення'
		@orders = Order.latest
	end

	def show 
		@title = "Замовлення №#{@order.id}"
		@order.set_off_unverified
	end	

	private

		def set_order
			@order = Order.includes(line_items: :product).find(params[:id])
		end	
end	