class SearchesController < ApplicationController
  authorize_resource

  def index
  	if params[:id]
  		@search = Search.find(params[:id])
  	else
  		@search = Search.new
  	end  	
  	@ads = @search.ads.page(params[:page]).per_page(15)
  end

  def create
    if params[:search][:search_id].present?
      @old_search = Search.find params[:search][:search_id]
      @search = @old_search.dup
      @search.dretect_search_field_from_down_filter_sections(params)
    else
      @search = Search.new(search_params)
      @search.car_model = nil if search_params[:make_id].nil?
    end
  	@search.year_from = correct_date(search_params[:year_from]) if search_params[:year_from].present?
  	@search.year_to   = correct_date( search_params[:year_to])  if search_params[:year_to].present?
    respond_to do |format|
      if @search.save
        cookies[:last_search] = @search.id
        format.html { redirect_to @search }
        format.json { render action: 'show', status: :created, location: @search }
      else
        format.html { render action: 'index' }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  	@search = Search.find(params[:id])
  	@ads = @search.ads.page(params[:page]).per_page(15)
  end

private
	def search_params
    params.require(:search).permit(:year_from, :year_to, 
                                   :price_from, :price_to, 
                                   :millage_from, :millage_to,
                                   :make_id, :car_model_id,
                                   :location, :radius,
                                   :order
                                   )
  end

  def correct_date year
	  JalaliDate.new(year.to_i,1,1).to_g 
  end
end 
