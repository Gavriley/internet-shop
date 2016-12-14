class LineItemsController < ApplicationController
	load_and_authorize_resource
	
	include CurrentCart
	before_action :set_cart
	before_action :set_line_item, only: [:count_up, :count_down, :destroy]

	def count_up
		@line_item.count += 1
		@line_item.save

		respond_to do |format|
			format.js
		end	
	end	

	def count_down
		@line_item.count -= 1
		@line_item.save

		respond_to do |format|
			if @line_item.count > 0
				format.js
			else
				@line_item.destroy
				check_cart and return
				format.js { render :destroy }
			end 	
		end	
	end	

	def create
		if params[:count].present? && (params[:count].to_i > 1)
			params[:count].to_i.times { @line_item = @cart.add_product(params[:product_id]).save }		
		else
			@line_item = @cart.add_product(params[:product_id]).save
		end	 

		respond_to do |format|
			format.js
			format.html { redirect_to products_path }
		end	
	end	

	def destroy
		@line_item.destroy
		check_cart and return

		respond_to do |format|
			format.js 
		end	
	end	

	private

		def check_cart
			if @cart.line_items.empty?
				@cart.destroy and session[:cart_id] = nil
				redirect_to root_path and return true
			end	
		end	

		def set_line_item
			@line_item = @cart.line_items.find(params[:id])
		end	
end	