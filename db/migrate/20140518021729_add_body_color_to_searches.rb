class AddBodyColorToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :body_color_id, :integer
    add_column :searches, :internal_color_id, :integer
  end
end
