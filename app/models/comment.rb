class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :post

	validates :content, presence: { message: "Заповніть контент коментаря" }, length: { maximum: 1000, message: "Максимальна довжина коментаря 1000 символів" }
end	