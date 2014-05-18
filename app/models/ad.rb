class Ad < ActiveRecord::Base
  default_scope { where(active: true) }

  geocoded_by :location
  # after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }
  
	has_one    :ad_other_field
	has_many   :image_urls

  belongs_to :user
  belongs_to :car_model
  belongs_to :make
  belongs_to :scrap
  belongs_to :internal_color
  belongs_to :body_color

  def internal_color_name
    Rails.cache.fetch([:internal_color, internal_color_id, :name], expires_in: 150.minutes) do 
      internal_color.try(:name)
    end
  end

  def body_color_name
    Rails.cache.fetch([:body_color, body_color_id, :name], expires_in: 150.minutes) do 
      body_color.try(:name)
    end
  end

  def car_model_name
    Rails.cache.fetch([:car_model, car_model_id, :name], expires_in: 5.minutes) do 
      car_model.try(:name)
    end
  end

  def make_name
    Rails.cache.fetch([:make, make_id, :name], expires_in: 5.minutes) do 
      make.try(:name)
    end
  end

  def recommended_ads count
    ads = Ad.all
    ads = ads.where(car_model_id: self.car_model_id)
    ads = ads.where.not(id: self.id)
    ads = ads.where("created_at > ?", 10.days.ago)
    ads = ads.order("RANDOM()")
    ads = ads.limit(count)
    if ads.size < 4
      ids = (ads.ids << self.id)
      ads2 = Ad.where(make_id: self.make_id)
      ads2 = ads2.where.not(id: ids)
      ads2 = ads2.where("created_at > ?", 10.days.ago)
      ads2 = ads2.order("RANDOM()")
      ads2 = ads2.limit(count - ads.size)
      ads = ads.concat ads2
    end
    ads
  end

  def big_images
    if self.user_id.nil?
      self.image_urls
    else
      # self.images
    end
  end

end
