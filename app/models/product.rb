class Product < ActiveRecord::Base
	# include Elasticsearch::Model
 #  include Elasticsearch::Model::Callbacks

	has_attached_file :thumbnail, styles: { large: "300x300>", medium: "200x200>", small: "150x150>" }
	
	before_destroy :check_product_in_cart

	has_many :comments
	has_many :line_items
	has_many :categories_products
	has_many :categories, through: :categories_products

	belongs_to :user

	validates :user, presence: { message: "Помилка при добавленні товару" }
	validates :title, presence: { message: "Заповніть поле заголовок" }, length: { maximum: 70, message: "Заголовок може містити максимум 70 символів" }
	validates :description, length: { maximum: 2000, message: "Опис може містити максимум 2000 символів" }
	validates :price, numericality: { greater_than_or_equal_to: 0.01, message: "Введіть коректну ціну" }
	
	validates_attachment :thumbnail, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "image/jpg"], message: "Некоректний формат мініатюри" }
	validates_with AttachmentSizeValidator, attributes: :thumbnail, less_than: 1.megabytes, message: "Максимальний розмір мініатюри 1 мегабайт"

	scope :latest, -> { where(published: true).order(created_at: :desc) }

	after_validation :clean_thumbnail_errors

	# searchable do	
	# 	text :title
	# end

	def validate_thumbnail?
	  errors[:thumbnail].blank?
	end

	private
		def check_product_in_cart
			if line_items.empty?
				return true
			else	
				notice = "Існують товарні позиції"
				return false
			end	
		end	

		def clean_thumbnail_errors
			errors.delete(:thumbnail)
		end	
end	