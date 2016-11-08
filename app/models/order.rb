class Order < ActiveRecord::Base
	has_many :line_items

	validates :email, presence: { message: "Заповніть поле e-mail" }, length: { maximum: 60, message: "e-mail може містити максимум 60 символів" }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Некоректний e-mail" }
	validates :name, presence: { message: "Заповніть поле імя" }, length: { maximum: 15, message: "Імя може містити максимум 15 символів" }
	validates :address, presence: { message: "Заповніть поле адреса" }, length: { maximum: 255, message: "Адреса може містити максимум 255 символів" }
end	