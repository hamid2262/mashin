class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer  :ad_id
      t.attachment :name
      t.timestamps
    end
    add_index :images, :ad_id
  end
end
