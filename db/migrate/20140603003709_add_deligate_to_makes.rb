class AddDeligateToMakes < ActiveRecord::Migration
  def up
    add_column :makes, :deligate, :integer 
    add_column :car_models, :deligate, :integer 
    execute "UPDATE makes SET deligate = id "
    execute "UPDATE car_models SET deligate = id "

    add_index :makes, :deligate
    add_index :car_models, :deligate
  end

  def down
    remove_column :makes, :deligate
    remove_column :car_models, :deligate
  end
end
