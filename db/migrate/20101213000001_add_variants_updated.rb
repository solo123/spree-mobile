class AddVariantsUpdated < ActiveRecord::Migration
  def self.up
    add_column :variants, :updated_at, :datetime
  end
  
  def self.down
    remove_column :variants, :updated_at
  end
end
