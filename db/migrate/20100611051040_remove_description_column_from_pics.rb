class RemoveDescriptionColumnFromPics < ActiveRecord::Migration
  def self.up
    remove_column :pics, :description
  end

  def self.down
    add_column :pics, :description, :text
  end
end
