class ScrapsController < ApplicationController
  authorize_resource
  def index
    if Rails.env.production?
      system "rake scrap --trace 2>&1 >> #{Rails.root}/log/rake.log &"
    else
      scrap_url = "http://obscure-woodland-9401.herokuapp.com/"
      scrap = Scrap.new
      scrap.url = scrap_url+"ads"
      scrap.save
      scrap.sweep    
    end

    redirect_to root_path    
  end
end