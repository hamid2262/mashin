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

private

  def find_ads
    ads = Ad.all.includes(:car_model, car_model: :make)
    ads = ads.order(find_order) 
    # conditions ads
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

  def conditions values
    # values = values.where("status = 2") 
    values
  end

end