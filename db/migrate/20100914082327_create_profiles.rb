class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.string :shop_name
      t.string :shop_type
      t.integer :sales_monthly
      t.string :brands
      t.string :grade

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
