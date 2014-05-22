class AddIndexOnAds2 < ActiveRecord::Migration
  def change
    add_index :ads, [:status, :latitude, :longitude, :make_id, :car_model_id, :price], name: "index_ads_on_status_lat_make_model_price"
    add_index :ads, [:status, :latitude, :longitude, :make_id, :usage_type, :year, :price], name: "index_ads_on_status_lat_make_usage_year_price"
    add_index :ads, [:status, :latitude, :longitude, :fuel, :price], name: "index_ads_on_status_lat_fuel_price"

    add_index :ads, [:status, :make_id, :car_model_id, :price], name: "index_ads_on_status_make_model_price"
    add_index :ads, [:status, :make_id, :usage_type, :year, :price], name: "index_ads_on_status_make_usage_year_price"
    add_index :ads, [:status, :price,   :fuel], name: "index_ads_on_status_fuel_price"
    add_index :ads, [:status, :damaged], name: "index_ads_on_status_damaged"
  end
end
