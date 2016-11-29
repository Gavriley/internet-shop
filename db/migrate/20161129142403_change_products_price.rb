class ChangeProductsPrice < ActiveRecord::Migration
  def up
  	Product.all.each do |product|
  		product.price = product.price / 10
  		product.save!
  	end	
  end

  def down 
  	Product.all.each do |product|
  		product.price = product.price * 10
  		product.save!
  	end	
  end	
end
