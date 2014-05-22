class AddStatusToAds < ActiveRecord::Migration
  def change
    add_column :ads, :status, :integer, default: 3 
    # 0 not complete, 1: completed and not-verified, 2: verified and active, 3: expired
    remove_column :ads, :active
  end
end
