class HomesController < ApplicationController
  load_and_authorize_resource

  def show
    @search = Search.new
    @ad_count = Home.todays_ads
    @makes = Home.makes
  end
end
