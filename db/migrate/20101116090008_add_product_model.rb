class AddProductModel < ActiveRecord::Migration
  def self.up
    add_column :products, :brand_id, :integer
    add_column :products, :model, :string
  end

  def self.down
    remove_column :products, :brand_id
    remove_column :products, :model
  end
end