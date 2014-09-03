class AddRefererToSearches < ActiveRecord::Migration
  def up
    add_column :searches, :referer, :string
    add_column :searches, :user_ip, :string
    add_index  :searches, :user_ip
  end

  def down
    remove_column :searches, :user_ip
    remove_column :searches, :referer
  end

end
