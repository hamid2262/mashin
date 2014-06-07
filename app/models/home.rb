class Home 

  def self.todays_ads_count
    Rails.cache.fetch([:ads, :todays_ads_count], expires_in: 10.minutes) do 
      Ad.where("updated_at > ?", beginning_of_today).where(status: 2).count
    end
  end

  def self.makes
    makes = Make.joins(:ads).group(['makes.name'])
    makes = makes.where("ads.updated_at > ?", Home.beginning_of_today)
    makes.order('COUNT(ads.make_id) DESC').count
  end

  def self.beginning_of_today
    Time.zone.now.beginning_of_day() #- 5.days
  end
end
