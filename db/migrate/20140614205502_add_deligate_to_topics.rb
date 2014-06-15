class AddDeligateToTopics < ActiveRecord::Migration
  def up
    add_column :topics, :deligate, :integer
    add_column :subtopics, :deligate, :integer
    add_column :subtopics, :order, :integer
    execute "UPDATE topics SET deligate = id "
    execute "UPDATE subtopics SET deligate = id "
  end

  def down
    remove_column :topics, :deligate, :integer
    remove_column :subtopics, :deligate, :integer    
    remove_column :subtopics, :order, :integer    
  end
end
