class AddStatusToAds < ActiveRecord::Migration
  def up
    add_column :ads, :status, :integer, default: 2
    # 0:  information entered
    # 1:  image uploaded 
    # 2:  verified and active
    # 30:  genral rejected 
    # 31:  image problem rejected 
    # 32:  tel problem rejected
    # 33:  price problem rejected
    # 4:  sold
    # 5:  expired
    remove_column :ads, :active
  end
  def down
    remove_column :ads, :status
    add_column :ads, :active, :boolean
  end
end
