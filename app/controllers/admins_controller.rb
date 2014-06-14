class AdminsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :initialize_admin
  load_and_authorize_resource
  
  def show
  end

  def searches
    @searches = @admin.searches(params[:user_ip]).page(params[:page]).per_page(15)
  end

  def users
    @users = @admin.users.page(params[:page]).per_page(15)    
  end

  def unverified_ads
    @ads = @admin.unverified_ads
  end

  def topics
    @topics = Topic.order(:order).all
  end

private
  def initialize_admin
    @admin = Admin.new
  end
end