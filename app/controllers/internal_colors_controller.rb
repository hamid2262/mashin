class InternalColorsController < ApplicationController
  load_and_authorize_resource
  before_action :set_internal_color, only: [:show, :edit, :update, :destroy]

  # GET /internal_colors
  # GET /internal_colors.json
  def index
    @internal_colors = InternalColor.all
  end

  # GET /internal_colors/1
  # GET /internal_colors/1.json
  def show
  end

  # GET /internal_colors/new
  def new
    @internal_color = InternalColor.new
  end

  # GET /internal_colors/1/edit
  def edit
  end

  # POST /internal_colors
  # POST /internal_colors.json
  def create
    @internal_color = InternalColor.new(internal_color_params)

    respond_to do |format|
      if @internal_color.save
        format.html { redirect_to @internal_color, notice: 'Internal color was successfully created.' }
        format.json { render action: 'show', status: :created, location: @internal_color }
      else
        format.html { render action: 'new' }
        format.json { render json: @internal_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /internal_colors/1
  # PATCH/PUT /internal_colors/1.json
  def update
    respond_to do |format|
      if @internal_color.update(internal_color_params)
        format.html { redirect_to @internal_color, notice: 'Internal color was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @internal_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /internal_colors/1
  # DELETE /internal_colors/1.json
  def destroy
    @internal_color.destroy
    respond_to do |format|
      format.html { redirect_to internal_colors_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_internal_color
      @internal_color = InternalColor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def internal_color_params
      params.require(:internal_color).permit(:name, :visible)
    end
end
