class LineItemsController < ApplicationController
	include CurrentCart
	before_action :set_cart, only: :create

	def create
		
		@line_item = @cart.add_product(params[:product_id])

		respond_to do |format|
			if @line_item.save
				format.js
			else
				format.js
			end	
		end	
	end	
end	