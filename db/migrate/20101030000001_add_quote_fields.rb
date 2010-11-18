class AddQuoteFields < ActiveRecord::Migration
  def self.up
    add_column :quotes, :rel_model, :string
  end

  def self.down
    remove_column :quotes, :rel_model
  end
end