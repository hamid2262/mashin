scrap_url = "http://obscure-woodland-9401.herokuapp.com/"
require "open-uri"

desc "scrap ads"
task :scrap => :environment do
  require 'nokogiri'
  scrap = Scrap.new
  scrap.url = scrap_url+"ads"
  scrap.sweep
end

desc "triger_scrap"
task :triger_scrap do
  open scrap_url+"scraps"
end

desc "clear clear_scrapdb"
task :clear_scrapdb do
  open scrap_url + "scraps/clear_db"
end
