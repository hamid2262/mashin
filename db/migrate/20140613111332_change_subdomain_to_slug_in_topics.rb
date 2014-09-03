class ChangeSubdomainToSlugInTopics < ActiveRecord::Migration
  def up
    rename_column :topics, :subdomain, :slug
    add_index :topics, :slug
  end
  def down
    rename_column :topics, :slug , :subdomain
  end
end
