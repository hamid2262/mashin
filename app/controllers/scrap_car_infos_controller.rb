class ScrapCarInfosController < ApplicationController
  skip_authorization_check
  def index
    if Rails.env.production?
      system "rake scrap_car_info --trace 2>&1 >> #{Rails.root}/log/rake.log &"
    else
      scrap_car_info = ScrapCarInfo.new(url: "http://car-info.herokuapp.com/infos")
      scrap_car_info.scrap
    end
    redirect_to root_path    
  end
end
