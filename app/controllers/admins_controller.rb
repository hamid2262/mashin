class AdminsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def show
    @admin = Admin.new#(current_user)
  end

  def searches
    @admin = Admin.new#(current_user)
    @searches = @admin.searches.page(params[:page]).per_page(15)
  end
end