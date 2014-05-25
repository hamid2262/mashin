class ImagesController < ApplicationController
  load_and_authorize_resource
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  # before_action :set_ad, only: [:create, :index]

  def index
    @ad =  Ad.find params[:ad_id]
    @image = Image.new
    @images = @ad.images
  end

  def show
  end

  def new
    @image = Image.new
  end

  def edit
  end

  def create
    @image = Image.create(image_params)
  end

  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    def set_image
      @image = Image.find(params[:id])
    end

    def set_ad
      @ad = Ad.find params[:ad_id]
    end

    def image_params
      params.require(:image).permit(:name, :ad_id)
    end
end
