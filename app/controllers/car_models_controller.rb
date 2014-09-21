class CarModelsController < ApplicationController
  before_action :load_car_model, only: :create
  before_action :set_car_model, only: [:show, :edit, :update, :destroy, :infos]
  authorize_resource

  # GET /car_models
  # GET /car_models.json
  def index
    @car_models = CarModel.includes(:make).order("makes.name,car_models.name").page(params[:page]).per_page(30)
  end

  # GET /car_models/1
  # GET /car_models/1.json
  def show
    @search = Search.new
    @built_years ||= built_years 
    @built_year = @built_years.order(:year).last
    @ads = @car_model.ads.page(params[:page]).per_page(15)
  end

  # GET /car_models/new
  def new
    @car_model = CarModel.new
  end

  # GET /car_models/1/edit
  def edit
  end

  # POST /car_models
  # POST /car_models.json
  def create
    @car_model = CarModel.new(car_model_params)

    respond_to do |format|
      if @car_model.save
        format.html { redirect_to @car_model, notice: 'Car model was successfully created.' }
        format.json { render action: 'show', status: :created, location: @car_model }
      else
        format.html { render action: 'new' }
        format.json { render json: @car_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_models/1
  # PATCH/PUT /car_models/1.json
  def update
    respond_to do |format|
      if @car_model.update(car_model_params)
        format.html { redirect_to :back }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @car_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_models/1
  # DELETE /car_models/1.json
  def destroy
    @car_model.destroy
    respond_to do |format|
      format.html { redirect_to car_models_url }
      format.json { head :no_content }
    end
  end

  def infos
    @built_years ||= built_years 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def built_years 
      @car_model.built_years.order(:year)
    end

    def set_car_model
      @make = Make.find_by slug: params[:make_id]
      @make = Make.find_by id: params[:make_id] if @make.nil?
      @car_model = @make.car_models.where(id: params[:id]).first
      @car_model = @make.car_models.where(slug: params[:id]).first if @car_model.nil?

      redirect_to searches_path if @car_model.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_model_params
      params.require(:car_model).permit(:name, :slug, :make_id, :deligate, :visible)
    end

    def load_car_model
      @car_model = CarModel.new(car_model_params)
    end

end
