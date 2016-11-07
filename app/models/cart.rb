class Cart < ActiveRecord::Base
	has_many :line_items, dependent: :destroy

	def add_product(product)
		item = line_items.find_by(product_id: product)

		if item
			item.count += 1
		else
			item = line_items.build(product_id: product)
		end	

		return item
	end	

	def total_price
		line_items.to_a.sum { |item| item.total_price }
	end	

	def total_count
		line_items.to_a.sum { |item| item.count }
	end
end	