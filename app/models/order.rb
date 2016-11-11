class Order < ActiveRecord::Base

	has_many :line_items

	# attr_accessor :liqpay_form

	# def as_json(options={})
	#   super(:include => [:liqpay_form])
	# end

	validates :email, presence: { message: "Заповніть поле e-mail" }, length: { maximum: 60, message: "e-mail може містити максимум 60 символів" }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Некоректний e-mail" }
	validates :name, presence: { message: "Заповніть поле імя" }, length: { maximum: 15, message: "Імя може містити максимум 15 символів" }
	validates :address, presence: { message: "Заповніть поле адреса" }, length: { maximum: 255, message: "Адреса може містити максимум 255 символів" }

	def add_line_items_from_cart(cart)
		cart.line_items.each do |line_item|
			line_item.cart_id = nil
			line_items << line_item
		end	
	end	

	state_machine :state, initial: :pending do
		# before_transition pending: :processing, do: :qwerty

		event :process do
			transition pending: :process
		end	

		event :failed do
			transition process: :failed
		end	

		event :success do 
			transition process: :success
		end	

		event :reversed do
			transition success: :reversed
		end	

		event :sandbox do
			transition process: :sandbox
		end	

		# state :processing do 
		# 	def qwerty
		# 		Time.zone.now
		# 	end	
		# end	
  end
  
end	