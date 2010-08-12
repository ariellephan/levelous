# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100630212134) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pic_id"
    t.text     "message"
    t.datetime "created_at"
  end

  create_table "completed_quests", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "quest_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"    # follower
    t.integer  "friend_id"  # followee
    t.datetime "created_at"
  end

  create_table "hearts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pic_id"
    t.datetime "created_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.string   "notification_type"
    t.integer  "object_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pics", :force => true do |t|
    t.string   "title"
    t.integer  "user_id",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "view_count",         :default => 0
    t.text     "description"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "author_id"
    t.text     "message"
    t.datetime "created_at"
  end

  create_table "quests", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "level_required"
    t.integer  "hearts_awarded"
    t.integer  "reputation_awarded"
    t.integer  "count_required"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "pic_id"
    t.integer  "tag_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                     :null => false
    t.string   "email",                                     :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "reputation",             :default => 0,     :null => false
    t.integer  "level",                  :default => 1,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "hearts_left",            :default => 10,    :null => false
    t.boolean  "is_admin",               :default => false, :null => false
    t.integer  "consecutive_login_days", :default => 1
    t.string   "perishable_token"
    t.boolean  "active"
    t.date     "last_login"
    t.string   "location"
  end

end
