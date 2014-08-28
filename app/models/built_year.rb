class BuiltYear < ActiveRecord::Base
  belongs_to :car_model

  def ads car_model
    ads = car_model.ads.where("year > ?", modified_year-1.day)
    ads = ads.where("year < ?", modified_year+1.year-1.day)
    ads = ads.where(status: 2)
    ads = ads.order("updated_at DESC")
    ads
  end

  private

  def modified_year
    if self.year < 1400
      "#{self.year + 621}-1-1".to_date
    else
      "#{self.year}-1-1".to_date
    end
    
  end
end
