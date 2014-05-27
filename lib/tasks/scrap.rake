bama_url = "http://bama1.herokuapp.com/"
takhtegaz_url = "http://takhtegaz.herokuapp.com/"
tejarat_url = "http://tejarat.herokuapp.com/"
require "open-uri"

desc "scrap bama ads"
task :scrap_bama => :environment do
  require 'nokogiri'
  scrap = Scrap.new
  scrap.url = bama_url+"ads"
  scrap.sweep
end

desc "scrap takhtegaz ads"
task :scrap_takhtegaz => :environment do
  require 'nokogiri'
  scrap = Scrap.new
  scrap.url = takhtegaz_url+"ads"
  scrap.sweep
end

desc "scrap tejarat ads"
task :scrap_tejarat => :environment do
  require 'nokogiri'
  scrap = Scrap.new
  scrap.url = tejarat_url+"ads"
  scrap.sweep
end

##############################
desc "triger_bama_scrap"
task :triger_bama_scrap do
  open bama_url+"scraps"
end

desc "triger_takhtegaz_scrap"
task :triger_takhtegaz_scrap do
  open takhtegaz_url+"scraps"
end

desc "triger_tejarat_scrap"
task :triger_tejarat_scrap do
  open tejarat_url+"scraps"
end

##############################
desc "clear clear_bamadb"
task :clear_bamadb do
  open bama_url + "scraps/clear_db"
end

desc "clear clear_takhtegazdb"
task :clear_takhtegazdb do
  open takhtegaz_url + "scraps/clear_db"
end

desc "clear clear_tejaratdb"
task :clear_tejaratdb do
  open tejarat_url + "scraps/clear_db"
end

