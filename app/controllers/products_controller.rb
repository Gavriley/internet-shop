class ProductsController < ApplicationController
	before_action :set_product, only: [:show, :edit, :update, :destroy]

	def index

	end
	
	def show

	end

	def new

	end

	def edit

	end

	def create

	end	

	def update

	end

	def destroy

	end	

	private
		def set_product
			@product = Product.find(params[:id])
		end	

		def product_params
			params.require(:product).permit(:title, :description, :price, :thumbnail, :published, { category_ids: [] })
		end	
end	