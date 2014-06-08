class SearchesController < ApplicationController
  before_action :load_search, only: :create
  load_and_authorize_resource

  def index
    @search = Search.create
    @ads = Ad.page(params[:page]).per_page(15)
    render "show"
  end

  def create
    if params[:search][:search_id].present?
      @old_search = Search.find params[:search][:search_id]
      @search = @old_search.dup
      if params[:search][:remove]
        @search.top_filter_list_remove_link(params)
      else
        @search.dretect_search_field_from_down_filter_sections(params)
      end
    else
      @search = Search.new(search_params)
      @search.car_model = nil if search_params[:make_id].nil?
    end
  	@search.year_from = correct_date( search_params[:year_from]) if search_params[:year_from].present?
  	@search.year_to   = correct_date( search_params[:year_to])   if search_params[:year_to].present?
    
    @search.user_location = guest_user_location
    @search.user_ip = session[:user_ip]
    @search.referer = session[:user_referer]
    @search.user = current_user if current_user

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

  def ajax 
  count = 0   
    filter_name = params[:filter_name]
    filter_value = params[:filter_value]
    @search = Search.find params[:search_id]

    case filter_name
    when "year_from"
      @search.year_from = correct_date( filter_value )
      @search.year_to = nil
    when "year_to"
      @search.year_to = correct_date( filter_value )
    else
      @search.send(filter_name+'=', filter_value)
    end

    if filter_name.include? "from"
      value_to = filter_name.gsub "from", ""
      value_to = "#{value_to}to"
      @search.send(value_to+'=', nil)
    end

    @search.save
    count = @search.count

    @data = t("search result", count: count)
    # redirect_to :back
  end

private
	def search_params
    params.require(:search).permit(
      :year_from, :year_to, 
      :price_from, :price_to, 
      :millage_from, :millage_to,
      :make_id, :car_model_id,
      :location, :radius,
      :order,
      :girbox, :fuel,
      :body_color_id, :internal_color_id
    )
  end

  def correct_date year
    year.present? ? DateTime.parse("#{year.to_i}-05-01") : nil
  end

  def load_search
    @search = Search.new(search_params)
  end

  def guest_user_location
    if session[:guest_user_country] and session[:guest_user_city]
      session[:guest_user_country] + "-" +session[:guest_user_city]     
    end
  end

end 
