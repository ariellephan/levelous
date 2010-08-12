class DropFeedbacks < ActiveRecord::Migration
  def self.up
    drop_table :feedbacks
  end

  def self.down
     create_table :feedbacks do |t|
        t.text :message
        t.timestamps
     end
  end
end
