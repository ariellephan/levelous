class AddHeartsLeftToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :hearts_left, :integer, :default => 10, :null => false
  end

  def self.down
    remove_column :users, :hearts_left
  end
end
