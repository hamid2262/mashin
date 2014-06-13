class ChangeSubdomainToSlugInTopics < ActiveRecord::Migration
  def change
    rename_column :topics, :subdomain, :slug
    add_index :topics, :slug
  end
end
