class ProductsController < ApplicationController
	before_action :set_product, only: [:show, :edit, :update, :destroy]
	skip_before_filter :verify_authenticity_token

	def index
		@title = "Головна"
		@products = Product.includes([:categories, :user]).latest             
	end
	
	def show

	end

	def new
		@title = "Новий товар"
		@product = Product.new
	end

	def edit
		@title = %{Редагувати "#{@product.title}"}
	end

	def create
		@product = Product.new(product_params)
		@product.user = current_user

		respond_to do |format|
			if @product.save
				format.html { redirect_to edit_product_path(@product), notice: "Продукт успішно створений" }
				format.js { redirect_to edit_product_path(@product), notice: "Продукт успішно створений" }
			else
				format.html { render :new }
				format.js 
				format.json { render json: @product.errors }
			end	
		end	
	end	

	def update
		@product.thumbnail.try(:destroy) if params[:drop_file]
		
		respond_to do |format|
			if @product.update(product_params)
				format.html { redirect_to edit_product_path(@product), notice: "Продукт успішно оновлено" }
			else
				format.js 
				format.json { render json: @product.errors }
			end	
		end
	end

	def destroy
		
	end	

	private
		def set_product
			@product = Product.includes([:categories, :user]).find(params[:id])
		end	

		def product_params
			params.require(:product).permit(:title, :description, :price, :thumbnail, :drop_file, :published, { category_ids: [] })
		end	
end	