class AddSubtopicIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :subtopic_id, :integer
    add_index :articles, :subtopic_id
  end
end
