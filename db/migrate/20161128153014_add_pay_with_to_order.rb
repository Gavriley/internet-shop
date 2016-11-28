class AddPayWithToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :pay_with, :string
  end
end
