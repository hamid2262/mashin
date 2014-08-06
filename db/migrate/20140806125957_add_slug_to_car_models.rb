class AddSlugToCarModels < ActiveRecord::Migration
  def change
    add_column :car_models, :slug, :string
    add_index  :car_models, :slug
  end
end
