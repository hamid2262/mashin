class AdsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  authorize_resource

  before_action :set_ad, only: [:show, :edit, :update, :destroy]
  before_action :adjust_fields, only: [:create, :update]

  # GET /ads
  # GET /ads.json
  def index
    @ads = Ad.all
  end

  # GET /ads/1
  # GET /ads/1.json
  def show
    @recommended_ads = @ad.recommended_ads 4
  end

  # GET /ads/new
  def new
    @ad = Ad.new
    @ad.build_ad_other_field
  end

  # GET /ads/1/edit
  def edit
  end

  # POST /ads
  # POST /ads.json
  def create
    @ad = Ad.new(ad_params)
    @ad.user = current_user
    @ad.status = 0
    respond_to do |format|
      if @ad.save
        format.html { redirect_to @ad, notice: 'Ad was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ad }
      else
        format.html { render action: 'new' }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ads/1
  # PATCH/PUT /ads/1.json
  def update
    respond_to do |format|
      if @ad.update(ad_params)
        format.html { redirect_to @ad, notice: 'Ad was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ads/1
  # DELETE /ads/1.json
  def destroy
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to ads_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad
      @ad = Ad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ad_params
      params.require(:ad).permit(:make_id, :car_model_id, 
                                  :year, :year_format, :year_shamsi,
                                  :price, 
                                  :millage, :fuel, :girbox, 
                                  :body_color_id, :internal_color_id, 
                                  :damaged, :location, :details,
                                   ad_other_field_attributes: [:id, :tel])
    end

    def adjust_fields
      ad_params[:price].gsub!(/\D/, "")
      ad_params[:millage].gsub!(/\D/, '')
    end

end
