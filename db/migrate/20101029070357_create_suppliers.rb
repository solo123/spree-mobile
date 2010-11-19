class CreateSuppliers < ActiveRecord::Migration
  def self.up
    create_table :suppliers do |t|
      t.string :name
      t.string :contact
      t.string :phone
      t.string :address
      t.integer :status, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :suppliers
  end
end
