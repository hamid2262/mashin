class ChangeIpTo < ActiveRecord::Migration
  def change
    change_column :searches, :ip, :string, limit: 250
    rename_column :searches, :ip, :user_location
  end
end
