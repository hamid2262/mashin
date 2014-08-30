require "open-uri"
desc "scrap car info"
task :scrap_car_info => :environment do
  require 'nokogiri'
  scrap_car_info = ScrapCarInfo.new(url: "http://car-info.herokuapp.com/infos")
  scrap_car_info.scrap
end
