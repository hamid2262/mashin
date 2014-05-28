class AddViewedToAdOtherFields < ActiveRecord::Migration
  def change
    add_column :ad_other_fields, :viewed, :integer, default: 0
    add_column :ad_other_fields, :updated_times, :integer, default: 5

  end
end
