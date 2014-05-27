class Home 
  
  def self.todays_ads
    Ad.where("updated_at > ?", beginning_of_today).count
  end

  def self.makes
    makes = Make.joins(:ads).group(['makes.name'])
    makes = makes.where("ads.updated_at > ?", Home.beginning_of_today)
    makes.order('COUNT(ads.make_id) DESC').limit(18).count
  end

  def self.beginning_of_today
    Time.zone.now.beginning_of_day()
  end
end
