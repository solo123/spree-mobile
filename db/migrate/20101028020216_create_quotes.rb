class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.string  :brand
      t.integer :brand_id
      t.string  :model
      t.integer :product_id
      t.decimal :price
      t.decimal :price_old
      t.string  :remark
      t.integer :suplier_id
      t.integer :employee_id
      t.integer :status, :default => 0

      t.timestamps
    end
    create_table :mobile_brands do |b|
      b.integer :taxon_id
      b.integer :count
      b.integer :rate
      
      b.timestamps
    end

  end

  def self.down
    drop_table :quotes
    drop_table :mobile_brands
  end
end
