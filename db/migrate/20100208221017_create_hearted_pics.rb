class CreateHeartedPics < ActiveRecord::Migration
  def self.up
    create_table :hearted_pics do |t|
      t.integer :user_id
      t.integer :pic_id
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :hearted_pics
  end
end
