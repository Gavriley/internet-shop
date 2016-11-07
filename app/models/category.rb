class Category < ActiveRecord::Base
	has_many :categories_products
	has_many :products, -> { order(created_at: :desc) }, through: :categories_products
	has_many :children, class_name: "Category", foreign_key: :parent_id
	
	belongs_to :parent, class_name: "Category", foreign_key: :parent_id
end	