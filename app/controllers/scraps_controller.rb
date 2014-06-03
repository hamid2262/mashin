class ScrapsController < ApplicationController
  load_and_authorize_resource
  def index
    if Rails.env.production?
      system "rake scrap --trace 2>&1 >> #{Rails.root}/log/rake.log &"
    else
      scrap = Scrap.new
      scrap.url = "http://tejarat.herokuapp.com/ads"
      # scrap.url = "http://takhtegaz.herokuapp.com/ads"
      scrap.sweep    
    end

    redirect_to root_path    
  end
end