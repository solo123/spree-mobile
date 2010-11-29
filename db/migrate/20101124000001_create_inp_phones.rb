class CreateInpPhones < ActiveRecord::Migration
  def self.up
    create_table :inp_phones do |t|
      t.integer :product_id
      t.string :name
      t.string :brand
      t.string :model
      t.string :model_1
      t.string :url
      t.text   :description
      t.integer :status, :default => 0

      t.timestamps
    end
    create_table :inp_phone_props do |t|
      t.integer :phone_id
      t.string :prop
      t.string :ref_prop
      t.string :val
      t.integer :status, :default => 0
    end
  end

  def self.down
    drop_table :inp_phones
    drop_table :inp_phone_props
  end
end