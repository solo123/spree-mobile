class CreateUserCodes < ActiveRecord::Migration
  def self.up
    create_table :user_codes do |t|
      t.string :mobile
      t.string :code
      t.string :token

      t.timestamps
    end
  end

  def self.down
    drop_table :user_codes
  end
end
