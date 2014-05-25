class AddStatusToAds < ActiveRecord::Migration
  def up
    add_column :ads, :status, :integer, default: 2
    # 0 information entered
    # 1: image uploaded 
    # 2: verified and active
    # 3: expired
    remove_column :ads, :active
  end
  def down
    remove_column :ads, :status
    add_column :ads, :active, :boolean
  end
end
