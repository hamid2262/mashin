class Search < ActiveRecord::Base
  # geocoded_by :location
  # after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }
  
	belongs_to :make
	belongs_to :car_model

	def year_from_shamsi
		year_from ? JalaliDate.new(year_from).year : ""
	end

	def year_to_shamsi
		year_to   ? JalaliDate.new(year_to).year : ""
	end

  def ads
    @ads ||= find_ads
  end

  def count
    ads.count 
  end

  def makes
    if make_id.nil?
      @makes = Make.joins(:ads).group('makes.name')
      @makes = conditions @makes 
      @makes = @makes.order('COUNT(ads.make_id) DESC').count
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

  def dretect_search_field_from_down_filter_sections params
    make_name      = params[:search][:make_name]
    car_model_name = params[:search][:car_model_name]
    if make_name.present? 
      make = Make.find_by(name: make_name)
      self.make_id = make.id    
    elsif car_model_name.present?
      car_model = CarModel.find_by(name: car_model_name)
      self.car_model_id = car_model.id 
    end
  end

private

  def find_ads
    ads = Ad.all.includes(:car_model, car_model: :make)
    ads = ads.order(find_order) 
    conditions ads
  end

  def conditions values
    values = values.where("active = true")

    values = values.where("year >= ?", year_from - 1.months) if year_from.present?
    values = values.where("year <= ?", year_to   + 11.months) if year_to.present?
    
    values = values.where("price >= ?", price_from ) if price_from.present?
    values = values.where("price <= ?", price_to ) if price_to.present?

    values = values.where("millage >= ?", millage_from) if millage_from.present?
    values = values.where("millage <= ?", millage_to) if millage_to.present?
    
    values = where_near_origin(values, location, find_radius) if location.present? and find_location.first

    values = values.where(make_id: make_id) if make_id.present?
    values = values.where(car_model_id: car_model_id) if car_model_id.present? and make_id.present?   
    values
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
			"created_at DESC"
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
