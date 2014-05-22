class AddDamagedToAds < ActiveRecord::Migration
  def change
    add_column :ads, :damaged, :integer
    remove_column :searches, :damaged, :boolean
    add_column :searches, :damaged, :integer
  end
end
