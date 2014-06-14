require "open-uri"
desc "scrap_articles"
task :scrap_articles => :environment do
  require 'nokogiri'
  scrap_article = ScrapArticle.new
  scrap_article.url = "http://khabarha.herokuapp.com/contents"
  scrap_article.sweep
end

desc "articles_scrap_triger"
task :articles_scrap_triger do
  open "http://khabarha.herokuapp.com/scraps"
end

