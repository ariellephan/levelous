class CreateCompletedQuests < ActiveRecord::Migration
  def self.up
    create_table :completed_quests do |t|
      t.integer :user_id, :null => false
      t.integer :quest_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :completed_quests
  end
  
end
