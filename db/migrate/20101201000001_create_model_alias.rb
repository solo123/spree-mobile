class CreateModelAlias < ActiveRecord::Migration
  def self.up
    create_table :model_alias do |t|
      t.integer :product_id
      t.integer :brand_id
      t.string :model

      t.timestamps
    end
  end

  def self.down
    drop_table :model_alias
  end
end