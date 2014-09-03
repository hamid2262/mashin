class AddIndexOnAds < ActiveRecord::Migration
  def up
    add_index :ads, [:active, :latitude, :longitude, :make_id, :car_model_id, :price], name: "index_ads_on_active_lat_make_model_price"
    add_index :ads, [:active, :latitude, :longitude, :make_id, :usage_type, :year, :price], name: "index_ads_on_active_lat_make_usage_year_price"
    add_index :ads, [:active, :latitude, :longitude, :fuel, :price], name: "index_ads_on_active_lat_fuel_price"
  end
end
