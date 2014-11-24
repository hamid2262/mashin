class MakesController < ApplicationController
  before_action :load_make, only: :create
  before_action :set_make, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @makes = Make.all.order(:name)
  end

  def show
    @search = Search.new
    @car_models = @make.popular_car_model_menu
    if session[:search_id]
      @search = Search.find(session[:search_id])
      session[:search_id] = nil
      @ads = @search.ads.page(params[:page]).per_page(15)      
    else
      @search = Search.new(make_id:@make.deligate_obj.id)
      @ads = @make.ads.page(params[:page]).per_page(15)
    end
  end

  def new
    @make = Make.new
  end

  def edit
  end

  def create
    @make = Make.new(make_params)

    respond_to do |format|
      if @make.save
        format.html { redirect_to @make, notice: 'Make was successfully created.' }
        format.json { render action: 'show', status: :created, location: @make }
      else
        format.html { render action: 'new' }
        format.json { render json: @make.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @make.update(make_params)
        format.html { redirect_to makes_path, notice: 'Make was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @make.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @make.destroy
    respond_to do |format|
      format.html { redirect_to makes_url }
      format.json { head :no_content }
    end
  end

  def scrap
    Make.scrap
    redirect_to makes_path
  end
  
  private
    def set_make
      @make = Make.find_by(slug: params[:id])
    end

    def make_params
      params.require(:make).permit(:name, :slug,:year_format, :deligate)
    end

    def load_make
      @make = Make.new(make_params)
    end

end
