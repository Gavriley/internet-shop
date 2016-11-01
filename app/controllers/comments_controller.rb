class CommentsController < ApplicationController
	before_action :set_product, only: [:create, :update, :destroy]
	before_action :set_comment, only: [:update, :destroy]

	def create

	end
	
	def update

	end

	def destroy

	end

	private
		def set_product
			@product = Product.find(params[:product_id])
		end	

		def set_comment
			@comment = Comment.find(params[:id])
		end	
end	