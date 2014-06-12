class CreateScrapArticles < ActiveRecord::Migration
  def change
    create_table :scrap_articles do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
