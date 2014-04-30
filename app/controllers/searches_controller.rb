class SearchesController < ApplicationController
  def index
  	if params[:id]
  		@search = Search.find(params[:id])
  	else
  		@search = Search.new
  	end  	
  	@ads = @search.ads.page(params[:page]).per_page(10)
  end

  def create
  	@search = Search.new(search_params)
  	@search.year_from = correct_date(search_params[:year_from]) if search_params[:year_from].present?
  	@search.year_to   = correct_date( search_params[:year_to])  if search_params[:year_to].present?

    respond_to do |format|
      if @search.save
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
  	@ads = @search.ads #.page(params[:page]).per_page(10)
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
