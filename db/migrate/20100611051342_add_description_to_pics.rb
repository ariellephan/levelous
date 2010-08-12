class AddDescriptionToPics < ActiveRecord::Migration
  def self.up
    add_column :pics, :description, :text
  end

  def self.down
    remove_column :pics, :description
  end
end
