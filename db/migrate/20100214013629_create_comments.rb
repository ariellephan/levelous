class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id
      t.integer :pic_id
      t.text :message
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :comments
  end
end
