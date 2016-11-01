class Category < ActiveRecord::Base
	has_many :categories_posts
	has_many :posts, through: :categories_posts
	has_many :parent, class_name: "Category", foreign_key: :parent

	belongs_to :children, class_name: "Category", foreign_key: :parent
end	