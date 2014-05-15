class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active, :boolean, default: true
    add_column :users, :slug, :string
    add_column :users, :slug_updated, :boolean,  default: false
    add_column :users, :admin, :boolean,  default: false
    add_column :users, :age, :integer
    add_column :users, :gender, :boolean
    add_column :users, :address, :string
    add_column :users, :details, :text

    add_index  :users, :slug
  end
end
