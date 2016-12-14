class CommentsController < ApplicationController
	load_and_authorize_resource

	before_action :set_product, only: [:create, :update, :destroy]
	before_action :set_comment, only: [:update, :destroy]

	def create
		@comment = Comment.new(comment_params)
		@comment.product = @product
		@comment.user = current_user

		respond_to do |format|
			
			if @comment.save
				format.js 
			else
				format.js
				format.json { render json: @comment.errors }
			end		
		end
	end
	
	def update
		respond_to do |format|
			
			if @comment.update(comment_params)
				format.js 
			else
				format.js
				format.json { render json: @comment.errors }
			end		
		end
	end

	def destroy
		@comment.destroy
		
		respond_to do |format|
			format.js
		end	
	end

	private
		def comment_params
			params.require(:comment).permit(:content)
		end	

		def set_product
			@product = Product.find(params[:product_id])
		end	

		def set_comment
			@comment = @product.comments.find(params[:id])
		end	
end	