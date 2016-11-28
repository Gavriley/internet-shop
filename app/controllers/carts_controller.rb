class CartsController < ApplicationController
	before_action :set_cart, only: [:destroy]
	rescue_from ActiveRecord::RecordNotFound, with: -> { redirect_to root_path }

	def index
		@title = "Корзина"
		@cart = Cart.includes(:line_items).find(session[:cart_id])
		@order = Order.new
	end
	
	def destroy
		@cart.destroy if @cart.id == session[:cart_id]
		session[:cart_id] = nil
		redirect_to root_path, notice: "Корзина пуста"
	end

	private
		def set_cart
			@cart = Cart.includes(:categories).find(params[:id])
		end	

		def cart_params
			params.fetch(:cart, {})
		end	
end	