class Admin::ProductsController < Admin::AdminController

	def dashboard
		
	end

	def index
		@title = "Товари"
		
		# @search = Product.search do
		# 	fulltext params[:search]
		# end	

		# @products = @search.results

		@products = Product.includes([:categories, :user]).latest  
	end

end	