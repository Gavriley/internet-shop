class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action { @categories = Category.includes(:children).where(parent_id: 0) }

  before_action :set_cart_params

	protected
		def set_cart_params
			if session[:cart_id]
				@cart_count = Cart.find(session[:cart_id]).total_count
				@cart_price = Cart.find(session[:cart_id]).total_price
			else
				@cart_count = 0
				@cart_price = 0.00
			end	
		end	

	  def configure_permitted_parameters
	    added_attrs = [:login, :email, :name, :password, :password_confirmation, :remember_me]
	    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
	    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
	  end
end
