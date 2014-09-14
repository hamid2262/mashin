class AdminsController < ApplicationController
  layout "application_others", only: [:topics, :subtopics]
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

  def car_models
    if params[:make]
      @car_models = @admin.car_models.where(make_id: params[:make][:id])
    else
      @car_models = @admin.car_models.page(params[:page]).per_page(30)
    end
  end

  def topics
    @topics = Topic.all
  end

  def subtopics
    @subtopics = Subtopic.order(:topic_id, :deligate)
  end

  def scrap_car_info_car_models
    Admin.scrap_car_info_car_models
    redirect_to :back
  end

private
  def initialize_admin
    @admin = Admin.new
  end
end