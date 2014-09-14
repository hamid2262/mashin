class Admin
  
  def searches user_ip
    if user_ip
      Search.where(user_ip: user_ip).order(created_at: :desc)      
    else
      Search.order(created_at: :desc)      
    end
  end

  def users
    User.order(created_at: :desc)
  end

  def unverified_ads
    Ad.where("status < 2").limit(20)
  end

  def car_models
    CarModel.joins(:make).order('makes.name').order('car_models.name')
  end

  def self.scrap_car_info_car_models
    url = "http://car-info.herokuapp.com/car_models"
    doc = Nokogiri::HTML(open(url))
    get_car_models doc
  end

  private

  def self.get_car_models doc
    rows = doc.css 'tr'
    rows.each do |row|
      make_name = row.at_css(".make").text if row.at_css(".make")
      car_model_name = row.at_css(".car_model").text if row.at_css(".car_model")
      make_slug = row.at_css(".make_slug").text if row.at_css(".make_slug")
      car_model_slug = row.at_css(".car_model_slug").text if row.at_css(".car_model_slug")
      
      if car_model_slug.present? 
        makes = Make.where(slug: make_slug)
        make_ids = makes.map{|m| m.id}
        if make_ids.present?
          car_models = CarModel.where(name: car_model_name, make_id: make_ids)
          car_models.update_all(slug: car_model_slug)
        # else
        #   make = Make.create(slug: slug, name: name) 
        end
      end
    end
  end

end 