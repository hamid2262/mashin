class HomesController < ApplicationController
  authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def show
    @search = Search.new
  end
end
