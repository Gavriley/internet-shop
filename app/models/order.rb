class Order < ActiveRecord::Base
	
	has_many :line_items

	validates :email, presence: { message: "Заповніть поле e-mail" }, length: { maximum: 60, message: "e-mail може містити максимум 60 символів" }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Некоректний e-mail" }
	validates :name, presence: { message: "Заповніть поле імя" }, length: { maximum: 15, message: "Імя може містити максимум 15 символів" }
	validates :address, presence: { message: "Заповніть поле адреса" }, length: { maximum: 255, message: "Адреса може містити максимум 255 символів" }

	def add_line_items_from_cart(cart)
		cart.line_items.each do |line_item|
			line_item.cart_id = nil
			line_items << line_item
		end	
	end	

	state_machine :state do
		
  end

end	