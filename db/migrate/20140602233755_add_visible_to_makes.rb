class AddVisibleToMakes < ActiveRecord::Migration
  def change
    add_column :makes, :visible, :boolean, default: true
    add_column :car_models, :visible, :boolean, default: true
  end
end
