class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :user_id
      t.string :notification_type
      t.integer :object_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
