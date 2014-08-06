class AddSlugToMakes < ActiveRecord::Migration
  def change
    add_column :makes, :slug, :string
    add_index :makes, :slug
  end
end
