class ChangeIpTo < ActiveRecord::Migration
  def up
    change_column :searches, :ip, :string, limit: 250
    rename_column :searches, :ip, :user_location
  end
  def down
    rename_column :searches, :user_location, :ip
    change_column :searches, :ip, :string, limit: 255
  end
end
