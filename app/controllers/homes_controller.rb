class HomesController < ApplicationController
  load_and_authorize_resource

  def show
    if current_user
      redirect_to dashboard_path
    end
    @search = Search.new
    @all_ads_count =Ad.all_ads_count
    @today_ad_count = Home.todays_ads_count
    @makes = Home.makes
  end
end
