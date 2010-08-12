class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.integer :user_id, :friend_id
      t.datetime "created_at"
    end
  end

  def self.down
    drop_table :friendships
  end
end
