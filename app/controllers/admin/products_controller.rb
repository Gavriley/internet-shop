class Admin::ProductsController < Admin::AdminController

	def dashboard
		
	end

	def index
		@title = "Товари"
		@products = Product.includes([:categories, :user]).latest  
	end

end	