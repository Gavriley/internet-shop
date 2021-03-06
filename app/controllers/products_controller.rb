class ProductsController < ApplicationController
  load_and_authorize_resource

  include ApplicationHelper

  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :delete_thumbnail, only: :update
  
  # skip_before_filter :verify_authenticity_token

  def index
    @title = "Головна"
    set_search_products 
  end
  
  def search
    search_products = set_search_products 5 if params[:search].present? 
    render json: { query: create_search_query(search_products) }, status: :ok
  end 

  def show
    @title = @product.title
    @comment = @product.comments.build
    @comments = @product.comments.includes(:user).order(created_at: :desc)
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
        format.js { redirect_to edit_product_path(@product), notice: "Товар успішно створений" }
      else
        format.js { render :product }
      end 
    end 
  end 

  def update
    if @product.update(product_params)
      flash[:notice] = "Товар успішно оновлено"
      render :product, format: :js
    else
      render :product, format: :js
    end 
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Товар знищено"
  end 

  def valid_thumbnail
    @product = Product.new(thumbnail: params[:thumbnail])
    @product.thumbnail_validator
    
    if @product.valid?
      render json: nil, status: :ok
    else
      render json: { errors: get_error_messages(@product) }, status: :unprocessable_entity
    end 
  end  

  private
    def set_search_products(per_page = 20)
      @search = Product.search do
      fulltext params[:search]
      with(:published, true)
      paginate page: 1, per_page: per_page
      order_by :id, :desc
      end
      @products = @search.results  
    end 

    def delete_thumbnail
      @product.thumbnail.try(:destroy) and @product.save if params[:drop_file]
    end 

    def set_product
      @product = Product.find(params[:id])
    end 

    def product_params
      params.require(:product).permit(:title, :description, :price, :thumbnail, :drop_file, :published, { category_ids: [] })
    end 
end 