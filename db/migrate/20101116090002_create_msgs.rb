class CreateMsgs < ActiveRecord::Migration
  def self.up
    create_table :msgs do |t|
      t.string :sender
      t.string :sendee
      t.integer :sendee_id
      t.string :address
      t.string :msg_type
      t.string :msg_title
      t.text :msg_body
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
