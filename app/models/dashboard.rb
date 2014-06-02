class Dashboard 

  def initialize user
    @user = user      
  end
  
  def my_ads
    @user.ads.order("updated_at DESC")
  end

  def ads
    @ads ||= find_ads
  end

  def price_from
    obj = preferences.select{|p| p.filter_name == "PriceFrom" }.first
    obj ? obj.filter_id.to_i / 1000000 : MIN_PRICE
  end

  def price_to
    obj = preferences.select{|p| p.filter_name == "PriceTo" }.first
    obj ? obj.filter_id.to_i / 1000000 : MAX_PRICE
  end

  def year_from
    obj = preferences.select{|p| p.filter_name == "YearFrom" }.first
    obj ? obj.filter_id.to_i  : MIN_YEAR
  end

  def year_to
    obj = preferences.select{|p| p.filter_name == "YearTo" }.first
    obj ? obj.filter_id.to_i  : MAX_YEAR
  end

  def elements model_name
    model_name_pl = model_name.pluralize
    results = model_name.constantize.all
    results = elements_conditoin results, model_name
    results = results.where.not(id: filtered_element_ids(model_name))
  end

  def filtered_elements model_name
    model = model_name.constantize
    model_name_pl = model_name.underscore.pluralize
    results = model.where(id: filtered_element_ids(model_name) )
    results
  end

  def non_models_elements arr_name
    array = (arr_name+"_ARR").constantize 
    array - non_models_filtered_elements(arr_name)
  end

  def non_models_filtered_elements(arr_name)
    array = (arr_name+"_ARR").constantize
    prefereds_ids(arr_name).map{|u| array[u]}
  end

private
  def elements_conditoin results, model_name
    if model_name == "CarModel"
      results = results.where(make_id: filtered_element_ids("Make"))
    end
    results  
  end

  def filtered_element_ids filter_name
    preferences = Preference.where(user_id: @user.id)
    preferences = preferences.where(filter_name: filter_name)
    target_ids = preferences.map { |p| p.filter_id }
    target_ids.uniq
  end

  def find_ads
    ads = Ad.all.includes(:car_model, car_model: :make)
    # ads = ads.order(find_order) 
    main_ads_condition ads
  end

  def main_ads_condition values
    values = values.where(ads:{status: 2}) 

    values = values.where("ads.price >= ?", range_filter("PriceFrom") ) if (range_filter("PriceFrom").present? and range_filter("PriceFrom") != MIN_PRICE)
    values = values.where("ads.price <= ?", range_filter("PriceTo") )     if (range_filter("PriceTo").present?     and range_filter("PriceTo") != MAX_PRICE)

    values = values.where("ads.year >= ?", year_from_filter ) if (year_from_filter.present? and year_from_filter != MIN_YEAR)
    values = values.where("ads.year <= ?", year_to_filter )   if (year_to_filter.present?   and   year_to_filter != MAX_YEAR)

    # values = values.where("ads.millage >= ?", millage_from) if millage_from.present?
    # values = values.where("ads.millage <= ?", millage_to) if millage_to.present?
    
    # values = where_near_origin(values, location, find_radius) if location.present? and find_location.first

    values = values.where( fuel: prefereds_ids("FUEL") ) if prefereds_ids("FUEL").present?

    girbox_arr = prefereds_ids("GIRBOX").map{|g| g==1 ? true : false}
    values = values.where( girbox: girbox_arr) if prefereds_ids("GIRBOX").present?

    values = values.where( make_id: prefereds_ids("Make") ) if prefereds_ids("Make").present?
    values = values.where( car_model_id: prefereds_ids("CarModel") ) if prefereds_ids("CarModel").present? and prefereds_ids("Make").present?   
    
    values = values.where( internal_color_id: prefereds_ids("InternalColor") ) if prefereds_ids("InternalColor").present?   
    values = values.where( body_color_id: prefereds_ids("BodyColor") ) if prefereds_ids("BodyColor").present? 
    values
  end

  def range_filter range_name 
    elements = preferences.select{|p| p.filter_name == range_name}
    elements.first.filter_id if elements.present?
  end

  def year_from_filter
    JalaliDate.new(range_filter("YearFrom") ,5,1).to_g
  end

  def year_to_filter
    JalaliDate.new(range_filter("YearTo") ,5,1).to_g
  end
    
  def preferences
    @preferences ||= @user.preferences
  end

  def prefereds_ids model_name
    elements = preferences.select{|p| p.filter_name == model_name}
    elements.map{ |p| p.filter_id }
  end

  def find_order
    case "self.order"
    when 'year'
      "year DESC"
    when "cheap"
      "price ASC"
    when "expencive"
      "price DESC"
    else
      "updated_at DESC"
    end
  end

end