class AddRefererToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :referer, :string
    add_column :searches, :user_ip, :string
    add_index  :searches, :user_ip
  end
end
