class Admin::ProductsController < Admin::AdminController
	before_action :set_product, only: :destroy

	def dashboard
		@title = "Майстерня"

		@orders = Order.latest.first(3)
		@products = Product.latest.first(10)
	end

	def index
		@title = "Товари"

		set_search_products

		respond_to do |format|
			format.html { render :index }
			format.js { render :products }
		end	 
	end

	def destroy
		@product.destroy
		redirect_to admin_products_path
	end	
	
	private
		def set_product
			@product = Product.includes([:categories, :user]).find(params[:id])
		end	

		def set_search_products
			@search = Product.search do
				fulltext params[:search_product]

				paginate page: params[:page], per_page: 10
				order_by :id, :desc
			end

			@products = @search.results
		end	
end	