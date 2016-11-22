class AddLastErrorToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :last_error, :string
  end
end
