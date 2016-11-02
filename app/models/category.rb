class Category < ActiveRecord::Base
	has_many :categories_posts
	has_many :posts, through: :categories_posts
	has_many :children, class_name: "Category", foreign_key: :parent_id
	
	belongs_to :parent, class_name: "Category", foreign_key: :parent_id
end	