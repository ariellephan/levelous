class AddViewCountToPics < ActiveRecord::Migration
  def self.up
    add_column :pics, :view_count, :integer, :default => 0
  end

  def self.down
    remove_column :pics, :view_count
  end
end
