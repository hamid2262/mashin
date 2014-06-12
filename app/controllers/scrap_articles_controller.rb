class ScrapArticlesController < ApplicationController
  load_and_authorize_resource
  def index
    if Rails.env.production?
      system "rake scrap_articles --trace &"
    else
      scrap_article = ScrapArticle.new
      scrap_article.url = "http://khabarha.herokuapp.com/contents"
      scrap_article.sweep
    end
    redirect_to root_path

  end

end
