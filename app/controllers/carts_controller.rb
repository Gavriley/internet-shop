class CartsController < ApplicationController
	before_action :set_cart, only: [:destroy]

	def index
		@cart = Cart.find(session[:cart_id])
	end
	
	def destroy
		@cart.destroy if @cart.id == session[:cart_id]
		session[:cart_id] = nil
		redirect_to root_path, notice: "Корзина пуста"
	end

	private
		def set_cart
			@cart = Cart.find(params[:id])
		end	

		def cart_params
			params.fetch(:cart, {})
		end	
end	