class AdminsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def show
    @admin = Admin.new
  end

  def searches
    @admin = Admin.new
    @searches = @admin.searches.page(params[:page]).per_page(15)
  end

  def users
    @admin = Admin.new
    @users = @admin.users.page(params[:page]).per_page(15)    
  end
end