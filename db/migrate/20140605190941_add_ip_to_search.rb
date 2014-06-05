class AddIpToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :ip, :string, limit:40
    add_column :searches, :user_id, :integer
  end
end
