class AdsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource

  before_action :set_ad, only: [:verify, :show, :edit, :update, :destroy]

  def index
    @ads = Ad.limit(10)
  end

  def unverifieds
    @ads = Ad.where("status < 2").limit(20)
  end

  def verify
    @ad.status = 2
    @ad.save
    redirect_to :back
  end

  def show
    @recommended_ads = @ad.recommended_ads 4
  end

  def new
    @ad = Ad.new
    @ad.build_ad_other_field
  end

  def edit
    @image = Image.new
  end

  def create
    @ad = Ad.new(my_ad_params)
    @ad.user = current_user
    @ad.status = 0
    respond_to do |format|
      if @ad.save
        format.html { redirect_to ad_images_path(@ad), notice: 'Ad was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ad }
      else
        format.html { render action: 'new' }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @ad.status = 1
    respond_to do |format|
      if @ad.update(my_ad_params)
        format.html { redirect_to @ad, notice: 'Ad was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to ads_url }
      format.json { head :no_content }
    end
  end

  private
    def set_ad
      @ad = Ad.find(params[:id])
    end

    def ad_params
      params.require(:ad).permit(
        :make_id, 
        :car_model_id, 
        :year_format, :year_shamsi, :year_miladi,
        :price, 
        :usage_type,
        :millage, :fuel, :girbox, 
        :body_color_id, :internal_color_id, 
        :damaged, :location, :details,
         ad_other_field_attributes: [:id, :tel])
    end

    def my_ad_params
      my_ad_params = ad_params
      
      my_ad_params[:price].gsub!(/\D/, "") if my_ad_params[:price]

      if my_ad_params[:millage]
        my_ad_params[:millage].gsub!(/\D/, '')    
      else
        my_ad_params[:millage] = nil
      end
      if my_ad_params[:year_format] == "true"
        my_ad_params[:year] =  "#{my_ad_params[:year_shamsi]}-5-5"
      else
        my_ad_params[:year] =  "#{my_ad_params[:year_miladi]}-5-5"
      end
      my_ad_params
    end

end
