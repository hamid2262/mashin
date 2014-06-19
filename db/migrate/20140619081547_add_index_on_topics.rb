class AddIndexOnTopics < ActiveRecord::Migration
  def change
    add_index :topics, :name
    add_index :subtopics, :name
  end
end
