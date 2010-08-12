class CreateQuests < ActiveRecord::Migration
  def self.up
    create_table :quests do |t|
      t.string :title
      t.string :description
      t.integer :level_required
      t.integer :hearts_awarded
      t.integer :reputation_awarded
      t.integer :count_required

      t.timestamps
    end
  end

  def self.down
    drop_table :quests
  end
end
