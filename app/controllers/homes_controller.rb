class HomesController < ApplicationController
  load_and_authorize_resource

  def show
    if current_user
      redirect_to dashboard_path
    end
    @search = Search.new
    @ad_count = Home.todays_ads
    @makes = Home.makes
  end
end
