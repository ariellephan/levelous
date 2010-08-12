class DropHeartedPicsTable < ActiveRecord::Migration
  def self.up
    drop_table :hearted_pics
  end

  def self.down
    create_table :hearted_pics do |t|
      t.integer :user_id
      t.integer :pic_id
      t.datetime :created_at
    end
  end
end
