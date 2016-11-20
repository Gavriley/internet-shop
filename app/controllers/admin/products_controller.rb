class Admin::ProductsController < Admin::AdminController

	def dashboard
		
	end

	def index
		@title = "Товари"
		@products = Product.latest  
	end

end	