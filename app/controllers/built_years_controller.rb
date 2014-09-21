class BuiltYearsController < ApplicationController
  before_action :set_built_year, only: [:show, :edit, :update, :destroy, :info]
  authorize_resource

  # GET /built_years
  # GET /built_years.json
  def index
    @built_years = BuiltYear.all
  end

  # GET /built_years/1
  # GET /built_years/1.json
  def show
    @search = Search.new
    @ads = @built_year.ads(@car_model).page(params[:page]).per_page(15)
  end

  # GET /built_years/new
  def new
    @built_year = BuiltYear.new
  end

  # GET /built_years/1/edit
  def edit
  end

  # POST /built_years
  # POST /built_years.json
  def create
    @built_year = BuiltYear.new(built_year_params)

    respond_to do |format|
      if @built_year.save
        format.html { redirect_to @built_year, notice: 'Built year was successfully created.' }
        format.json { render action: 'show', status: :created, location: @built_year }
      else
        format.html { render action: 'new' }
        format.json { render json: @built_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /built_years/1
  # PATCH/PUT /built_years/1.json
  def update
    respond_to do |format|
      if @built_year.update(built_year_params)
        format.html { redirect_to @built_year, notice: 'Built year was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @built_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /built_years/1
  # DELETE /built_years/1.json
  def destroy
    @built_year.destroy
    respond_to do |format|
      format.html { redirect_to built_years_url }
      format.json { head :no_content }
    end
  end

  def info
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_built_year
      @make = Make.find_by slug: params[:make_id]
      @make = Make.find_by id: params[:make_id] if  @make.nil?
      @car_model  = @make.car_models.where(id: params[:car_model_id]).first
      @car_model  = @make.car_models.where(slug: params[:car_model_id]).first if @car_model.nil?
      
      @built_year = @car_model.built_years.where(id: params[:id]).first 
      @built_year = @car_model.built_years.where(year: params[:id]).first if @built_year.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def built_year_params
      params.require(:built_year).permit(:year, :gearbox, :engine_displacement)
    end
end
