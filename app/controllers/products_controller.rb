class ProductsController < ApplicationController
	include ApplicationHelper

	before_action :set_product, only: [:show, :edit, :update, :destroy]
	
	skip_before_filter :verify_authenticity_token

	def index
		# HardWorker.perform_in(200.second, 'SidekiqNew')

		@title = "Головна"

		# @products = Product.includes([:categories, :user]).latest

		@search = Product.search do
			fulltext params[:search]

			paginate page: 1, per_page: 40
			order_by :id, :desc
		end

		@products = @search.results   

		File.open('/home/darkness/insilico/log.txt', 'w') { |f| f << "#{@search.total}"    }

		# @products = Product.search('lorem').records
	end
	
	def search

		@search = Product.search do
			fulltext params[:search]

			paginate page: 1, per_page: 7
			order_by :id, :desc
		end if params[:search] != ""

		@products = @search.try(:results)   

		# @query = @products.map { |product| { product.id => product.title } }.reduce(:merge)

		if @products.present?
			@query = '<ul>'
			@products.each { |product| @query += "<li><a href='/products/#{product.id}'>#{product.title}</a></li>" }
			@query += '</ul>'.html_safe
		end
			
		respond_to do |format|
			format.json { render json: { query: @query }, status: :ok }
		end	
	end	

	def show
		@title = @product.title

		@comment = @product.comments.build
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

	def valid_thumbnail
		@product = Product.new(thumbnail: params[:thumbnail])

		@product.valid?

		@product.errors.delete(:title) if @product.errors.has_key?(:title)
		@product.errors.delete(:user) if @product.errors.has_key?(:user)
		@product.errors.delete(:description) if @product.errors.has_key?(:description)
		@product.errors.delete(:price) if @product.errors.has_key?(:price)

		# File.open('/home/darkness/insilico/log.txt', 'w') { |f| f << @product.thumbnail }
		respond_to do |format|
			if @product.errors.any?
				format.json { render :create, json: { errors: get_error_messages(@product) }, status: :unprocessable_entity }
			else
				format.json { render :create, json: nil, status: :ok }
			end	
		end	
	end	

	private
		def set_product
			@product = Product.includes([:categories, :user]).find(params[:id])
		end	

		def product_params
			params.require(:product).permit(:title, :description, :price, :thumbnail, :drop_file, :published, { category_ids: [] })
		end	
end	