class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.belongs_to :topic, index: true
      t.string :thumb
      t.string :truncate
      t.string :url

      t.timestamps
    end
    add_index :articles, :url
  end
end
