class BodyColorsController < ApplicationController
  authorize_resource
  before_action :set_body_color, only: [:show, :edit, :update, :destroy]

  # GET /body_colors
  # GET /body_colors.json
  def index
    @body_colors = BodyColor.all
  end

  # GET /body_colors/1
  # GET /body_colors/1.json
  def show
  end

  # GET /body_colors/new
  def new
    @body_color = BodyColor.new
  end

  # GET /body_colors/1/edit
  def edit
  end

  # POST /body_colors
  # POST /body_colors.json
  def create
    @body_color = BodyColor.new(body_color_params)

    respond_to do |format|
      if @body_color.save
        format.html { redirect_to @body_color, notice: 'Body color was successfully created.' }
        format.json { render action: 'show', status: :created, location: @body_color }
      else
        format.html { render action: 'new' }
        format.json { render json: @body_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /body_colors/1
  # PATCH/PUT /body_colors/1.json
  def update
    respond_to do |format|
      if @body_color.update(body_color_params)
        format.html { redirect_to @body_color, notice: 'Body color was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @body_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /body_colors/1
  # DELETE /body_colors/1.json
  def destroy
    @body_color.destroy
    respond_to do |format|
      format.html { redirect_to body_colors_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_body_color
      @body_color = BodyColor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def body_color_params
      params.require(:body_color).permit(:name, :visible)
    end
end
