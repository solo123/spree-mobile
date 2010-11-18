class AddMobileFields < ActiveRecord::Migration
  def self.up
    add_column :mobiles, :brand_id, :integer
    add_column :mobiles, :price_memo, :string
  end

  def self.down
    remove_column :mobiles, :brand_id
    remove_column :mobiles, :price_memo
  end
end