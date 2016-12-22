class CartsController < ApplicationController
	include ApplicationHelper

	before_action :set_cart, only: [:destroy]

	rescue_from ActiveRecord::RecordNotFound, with: -> { redirect_to root_path }

	load_and_authorize_resource
	
	def index
		@title = "Корзина"
		@cart = Cart.includes(:line_items).find(cookies[:cart_id])
		@order = Order.new
	end
	
	def destroy
		@cart.destroy if @cart.id == cookies[:cart_id]
		cookies[:cart_id] = nil
		redirect_to root_path, notice: "Корзина пуста"
	end

	def clean
		render json: { cart: get_params_cart }, status: :ok 
	end	

	private
		def set_cart
			@cart = Cart.includes(:line_items).find(params[:id])
		end	

		def cart_params
			params.fetch(:cart, {})
		end	
end	