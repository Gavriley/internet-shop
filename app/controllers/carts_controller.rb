class CartsController < ApplicationController
	before_action :set_cart, only: [:create, :destroy]

	def create

	end
	
	def destroy

	end

	private
		def set_cart
			@cart = Cart.find(params[:id])
		end	

		def cart_params
			params.fetch(:cart, {})
		end	
end	