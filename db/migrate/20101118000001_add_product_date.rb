class AddProductDate < ActiveRecord::Migration
  def self.up
    add_column :products, :list_date, :string
  end

  def self.down
    remove_column :products, :list_date
  end
end