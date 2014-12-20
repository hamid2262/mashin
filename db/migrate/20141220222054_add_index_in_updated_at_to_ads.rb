class AddIndexInUpdatedAtToAds < ActiveRecord::Migration
  def up
    add_index :ads, :updated_at
  end

  def down
    remove_index :ads, :updated_at
  end
end
