class DashboardsController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check
  def show
    @dashboard = Dashboard.new(current_user)
    @ads       = @dashboard.ads.page(params[:page]).per_page(15)
  end

end