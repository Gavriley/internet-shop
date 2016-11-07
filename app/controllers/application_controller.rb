class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action { @categories = Category.where(parent_id: 0) }
  
  include CurrentCart
	before_action :set_cart
end
