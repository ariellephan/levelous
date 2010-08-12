class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :null => false
      t.string :email, :null => false
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :reputation, :null => false, :default => 0
      t.integer :level, :null => false, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
