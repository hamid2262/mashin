class TopicsController < ApplicationController
  layout "application_others"
  before_action :load_topic, only: :create
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.menus.ordered
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @articles = @topic.same_topic_articles
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        @topic.update(deligate: @topic.id)
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @topic }
      else
        format.html { render action: 'new' }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to :back }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_admin_path }
      format.json { head :no_content }
    end
  end

  private
    def topic_params
      params.require(:topic).permit(:name, :slug, :order, :deligate)
    end

    def load_topic
      @topic = Topic.new(topic_params)
    end

    def set_topic
      @topic = Topic.find_by(slug: params[:id])
    end

end
