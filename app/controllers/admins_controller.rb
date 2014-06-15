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

  def topics
    @topics = Topic.all
  end

  def subtopics
    @subtopics = Subtopic.order(:topic_id, :deligate)
  end

private
  def initialize_admin
    @admin = Admin.new
  end
end