class CreateAddrs < ActiveRecord::Migration
  def self.up
    create_table :addrs do |t|
      t.string :type
      t.integer :ref_id

      t.string :name
      t.string :address
      t.string :phone
      t.string :zipcode
      t.string :province
      t.string :city
      t.string :notes
      t.integer :catalog

      t.timestamps
    end
  end

  def self.down
    drop_table :addrs
  end
end
