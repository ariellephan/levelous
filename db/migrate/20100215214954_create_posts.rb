class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id
      t.integer :author_id
      t.text :message
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :posts
  end
end
