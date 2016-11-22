class CategoriesController < ApplicationController
	before_action :set_category, only: :show

	def show
		@title = "Категорія: #{@category.name}"
		@products = @category.products
	end	

	private
		def set_category
			@category = Category.includes(:products).find(params[:id])
		end	
end	