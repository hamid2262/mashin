class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer :user_id
      t.string  :filter_name
      t.integer :filter_id

      t.timestamps
    end
    add_index :preferences, [:user_id, :filter_name, :filter_id]
  end
end
