require 'active_record/fixtures'
class AddRoles < ActiveRecord::Migration
  def self.up
    down
    directory = File.join(File.dirname(__FILE__), 'data' )
    Fixtures.create_fixtures(directory, "roles" )
  end
  
  def self.down
    Role.delete(:conditions => 'id>10 and id<20')
  end
end
