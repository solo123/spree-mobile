class CreateUserManagers < ActiveRecord::Migration
  def self.up
    create_table :user_managers do |t|
      t.integer :user_id
      t.integer :employee_id
      t.integer :operator_id
      t.string :manage_type

      t.timestamps
    end
  end

  def self.down
    drop_table :user_managers
  end
end
