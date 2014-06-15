class CreateSubtopics < ActiveRecord::Migration
  def change
    create_table :subtopics do |t|
      t.belongs_to :topic, index: true
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :subtopics, :slug
  end
end
