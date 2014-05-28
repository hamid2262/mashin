class DashboardsController < ApplicationController

  before_filter :authenticate_user!
  skip_authorization_check
  def show
    @dashboard      = Dashboard.new(current_user)
    # @timeline       = @dashboard.timeline.page(params[:page]).per_page(10)

  end

end