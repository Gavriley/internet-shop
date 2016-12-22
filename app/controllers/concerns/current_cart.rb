module CurrentCart extend ActiveSupport::Concern
	private
		def set_cart
			begin
				@cart = Cart.find(cookies[:cart_id])

				CleanerCartWorker.cancel! cookies[:cleaner_cart_id] if cookies[:cleaner_cart_id].present?
			rescue ActiveRecord::RecordNotFound
				@cart = Cart.create
			ensure	
				cleaner_cart_id = CleanerCartWorker.perform_in(1.year, @cart.id)

				cookies[:cart_id] = { value: @cart.id, expires: 1.year.from_now }
				cookies[:cleaner_cart_id] = { value: cleaner_cart_id, expires: 1.year.from_now }
			end	
		end	

		def destroy_cart
			Cart.destroy(cookies[:cart_id])
			cookies.delete :cart_id
		end	
end	