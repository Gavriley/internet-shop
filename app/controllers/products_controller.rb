class ProductsController < ApplicationController
	before_action :set_product, only: [:show, :edit, :update, :destroy]

	def index
		@title = "Головна"
		@products = Product.latest

		# require 'liqpay'
		# liqpay = Liqpay.new
		# res = liqpay.api 'invoice/send', { email: 'gavrileypetro@gmail.com', amount: 100, currency: 'UAH',
		#   order_id: 'qwerty_12', 
		#   sandbox: 1,
		#   goods: [{
		#               amount: 100,
		#               count: 6,
		#               unit: 'шт.',
		#               name: 'Lorem' }]}

		# File.open('/home/darkness/insilico/log.txt', 'w') { |f| f << res }              
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

		respond_to do |format|
			if @product.save
				format.js { redirect_to edit_product_path(@product), notice: "Продукт успішно створений" }
			else
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
			@product = Product.find(params[:id])
		end	

		def product_params
			params.require(:product).permit(:title, :description, :price, :thumbnail, :drop_file, :published, { category_ids: [] })
		end	
end	