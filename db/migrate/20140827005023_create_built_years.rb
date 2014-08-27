class CreateBuiltYears < ActiveRecord::Migration
  def change
    create_table :built_years do |t|
      t.integer :year
      t.integer :make_id
      t.integer :car_model_id

      t.string  :image
      
      t.string  :gearbox
      t.string  :diff
      t.integer :engine_displacement
      t.integer :cylinder
      t.integer :soupape

      t.string  :power
      t.string  :torque

      t.integer :length
      t.integer :width
      t.integer :height

      t.integer :speed
      t.float   :acceleration

      t.float   :fuel_consumption
      t.integer :tank_size
      
      t.string  :tire    
      t.string  :emission_standards    
      

      t.string  :airbag  
      t.string  :brake
      t.string  :tahvie_hava
      t.string  :seats
      t.string  :shisheha
      t.string  :ayneha
      t.string  :cheraghha
      t.string  :other_facilities

      t.timestamps
    end
    add_index :built_years, :year
    add_index :built_years, :make_id
    add_index :built_years, :car_model_id
  end
end
