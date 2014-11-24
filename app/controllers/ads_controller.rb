class AdsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  before_action :load_ad, only: :create
  authorize_resource

  before_action :set_ad, only: [:verify, :show, :edit, :update, :destroy]

  def index
    @ads = Ad.limit(10)
  end

  def verify
    AdsNotificationMailer.ad_result(@ad, params[:code]).deliver
    @ad.verifying params[:code]
    redirect_to :back
  end

  def show
    if @ad.nil?
      redirect_to root_url 
      return
    end
    @make = @ad.make.deligate_obj
    redirect_if_ad_expired
    @recommended_ads = @ad.recommended_ads 4
    begin
      @ad.view_counter_increment(current_user)
    rescue
    end
  end

  def new
    @ad = Ad.new
    @ad.build_ad_other_field
  end

  def touch
    ad = Ad.find(params[:id])
    ad.updated_times_decrement
    redirect_to :back
  end

  def sold
    ad = Ad.find(params[:id])
    ad.status = 40
    ad.save
    redirect_to :back
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
        @ad.updated_times_decrement
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
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    def set_ad
      @ad = Ad.find_by(id: params[:id])
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

    def load_ad
      @ad = Ad.new(ad_params)
    end

    def redirect_if_ad_expired
      if [5, 50].include? @ad.status
        if  @ad.car_model.deligate_obj
          redirect_to [@make, @ad.car_model.deligate_obj] 
        else
          redirect_to @make if @make
        end
      end
    end
end
