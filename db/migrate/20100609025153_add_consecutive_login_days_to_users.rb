class AddConsecutiveLoginDaysToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :consecutive_login_days, :integer, :default => 1
  end

  def self.down
    remove_column :users, :consecutive_login_days
  end
end
