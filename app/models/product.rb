class Product < ActiveRecord::Base
	has_attached_file :thumbnail, styles: { large: "300x300>", medium: "200x200>", small: "150x150>" }
	
	has_many :comments
	has_many :line_items
	has_many :categories_posts
	has_many :categories, through: :categories_posts

	belongs_to :user

	validates :title, presence: { message: "Заповніть поле заголовок" }, length: { maximum: 70, message: "Заголовок може містити максимум 70 символів" }
	validates :description, length: { maximum: 2000, message: "Опис може містити максимум 2000 символів" }
	validates :price, numericality: { grater_than_or_equal_to: 0.01, message: "Введіть коректну ціну" }
	
	validates_attachment :thumbnail, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "image/jpg"], message: "Некоректний формат мініатюри" }
	validates_with AttachmentSizeValidator, attributes: :thumbnail, less_than: 1.megabytes, message: "Максимальний розмір мініатюри 1 мегабайт"

	scope :latest, -> { where(published: true).order(created_at: :desc) }
end	