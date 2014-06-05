class Search < ActiveRecord::Base
  # geocoded_by :location
  # after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }
  
	belongs_to :make
  belongs_to :car_model
  belongs_to :body_color
  belongs_to :internal_color
	belongs_to :user

  def ads
    @ads ||= find_ads
  end

  def count
    ads.count 
  end

  def makes
    if make_id.nil?
      makes = Make.joins(:ads).group('makes.name')
      makes = conditions makes 
      makes.order('COUNT(ads.make_id) DESC').count
    end
  end

  def car_models
    if car_model_id.nil?
      @car_models = CarModel.joins(:ads).group('car_models.name')
      @car_models = conditions @car_models 
      @car_models = @car_models.order('COUNT(ads.car_model_id) DESC').count
      @car_models.sort_by { |name, count| count }.reverse
    end
  end

  def fuels
    if fuel.nil?
      fuels = Ad.group('fuel')
      fuels = conditions fuels 
      fuels.order('COUNT(ads.fuel) DESC').count
    end
  end

  def girboxes
    if girbox.nil?
      girboxes = Ad.group('girbox')
      girboxes = conditions girboxes 
      girboxes.order('COUNT(ads.girbox) DESC').count
    end
  end

  def body_colors
    if body_color_id.nil?
      body_colors = BodyColor.joins(:ads).group('body_colors.name')
      body_colors = conditions body_colors 
      body_colors.order('COUNT(ads.body_color_id) DESC').count
    end
  end

  def internal_colors
    if internal_color_id.nil?
      internal_colors = InternalColor.joins(:ads).group('internal_colors.name')
      internal_colors = conditions internal_colors 
      internal_colors.order('COUNT(ads.internal_color_id) DESC').count
    end
  end

  def dretect_search_field_from_down_filter_sections params
    make_name           = params[:search][:make_name]
    car_model_name      = params[:search][:car_model_name]
    body_color_name     = params[:search][:body_color_name]
    internal_color_name = params[:search][:internal_color_name]
    fuel_name           = params[:search][:fuel_name]
    girbox_name         = params[:search][:girbox_name]
    if make_name.present? 
      make = Make.find_by(name: make_name)
      self.make_id = make.id    
    elsif car_model_name.present?
      car_model = CarModel.find_by(name: car_model_name)
      self.car_model_id = car_model.id 
    elsif fuel_name.present?
      self.fuel = fuel_name
    elsif girbox_name.present?
      self.girbox = girbox_name
    elsif body_color_name.present?
      body_color = BodyColor.find_by(name: body_color_name)
      self.body_color_id = body_color.id 
    elsif internal_color_name.present?
      internal_color = InternalColor.find_by(name: internal_color_name)
      self.internal_color_id = internal_color.id 
    end
  end

  def top_filter_list_remove_link params
    location            = params[:search][:location_id]
    radius              = params[:search][:radius_id]
    make_id             = params[:search][:make_id]
    car_model_id        = params[:search][:car_model_id]
    fuel                = params[:search][:fuel_id]
    girbox_id           = params[:search][:girbox_id]
    year_from           = params[:search][:year_from_id]
    year_to             = params[:search][:year_to_id]
    price_from          = params[:search][:price_from_id]
    price_to            = params[:search][:price_to_id]
    millage_from        = params[:search][:millage_from_id]
    millage_to          = params[:search][:millage_to_id]
    body_color_id       = params[:search][:body_color_id]
    internal_color_id   = params[:search][:internal_color_id]
    order               = params[:search][:order_id]
    
    if make_id.present?
      self.make_id      = nil
      self.car_model_id = nil
    end
    if location.present?
      self.location     = nil 
      self.radius       = nil
    end
    self.radius            = nil if radius.present?
    self.car_model_id      = nil if car_model_id.present?
    self.fuel              = nil if fuel.present?
    self.girbox            = nil if girbox_id != nil
    self.year_from         = nil if year_from.present?
    self.year_to           = nil if year_to.present?
    self.price_from        = nil if price_from.present?
    self.price_to          = nil if price_to.present?
    self.millage_from      = nil if millage_from.present?
    self.millage_to        = nil if millage_to.present?
    self.body_color_id     = nil if body_color_id.present?
    self.internal_color_id = nil if internal_color_id.present?
    self.order             = nil if order.present?
  end

private

  def find_ads
    ads = Ad.all.includes(:car_model, car_model: :make)
    ads = ads.order(find_order) 
    conditions ads
  end

  def conditions values
    values = values.where("status = 2") 

    values = values.where("ads.year >= ?", year_from - 1.months) if year_from.present?
    values = values.where("ads.year <= ?", year_to   + 11.months) if year_to.present?
    
    values = values.where.not("ads.price = 0").where("ads.price >= ?", price_from ) if price_from.present?
    values = values.where.not("ads.price = 0").where("ads.price <= ?", price_to ) if price_to.present?

    values = values.where("ads.millage >= ?", millage_from) if millage_from.present?
    values = values.where("ads.millage <= ?", millage_to) if millage_to.present?
    
    values = values.where("ads.body_color_id = ?", body_color_id) if body_color_id.present?
    values = values.where("ads.internal_color_id = ?", internal_color_id) if internal_color_id.present?
    
    values = where_near_origin(values, location, find_radius) if location.present? and find_location.first

    values = values.where("ads.fuel=?", fuel) if fuel.present?
    values = values.where("ads.girbox=?", girbox) if girbox != nil
    
    values = values.where( ads:{ make_id: find_make_deligates } ) if make_id.present?
    values = values.where( ads:{ car_model_id: find_car_model_deligates } ) if car_model_id.present? and make_id.present?   
    values
  end

  def find_make_deligates
    make = Make.find make_id
    Make.where(deligate: make.deligate).ids
  end

  def find_car_model_deligates
    car_model = CarModel.find car_model_id
    CarModel.where(deligate: car_model.deligate).ids
  end

	def find_order
		case self.order
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

	def find_radius
		 self.radius ? self.radius : 100
	end

  def where_near_origin values, location, cycle
    lat,lng = find_location
    values.where(" sqrt( power(latitude - ?, 2) + power(longitude - ?, 2) ) < ?", lat, lng, cycle.to_f / 110)
  end

	def find_location
    myloc = Location.where(name: self.location).first
    if myloc && myloc.latitude
      lat = myloc.latitude
      lng = myloc.longitude
    else
      loc = Geocoder.search(self.location)[0]
      lat = loc.try(:latitude)
      lng = loc.try(:longitude)
      Location.create(name: self.location, latitude: lat, longitude: lng)  if lng
    end
    [lat, lng]
	end

end
