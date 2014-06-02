class Ad < ActiveRecord::Base
  # default_scope { where(active: true) }
  attr_accessor :year_shamsi, :year_miladi
  geocoded_by :location
  after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }

  scope :active, -> { where(status: 3) }

  # validates :girbox, :inclusion => {:in => [true, false]}
  validates :make_id, presence: true
  validates :car_model_id, presence: true
  validates :fuel, presence: true
  validates :price, presence: true
  # validates :year, presence: true

	has_one    :ad_other_field, dependent: :destroy
  accepts_nested_attributes_for :ad_other_field, allow_destroy: true
	
  has_many   :image_urls, dependent: :destroy
  has_many   :images, dependent: :destroy

  belongs_to :user
  belongs_to :car_model
  belongs_to :make
  belongs_to :scrap
  belongs_to :internal_color
  belongs_to :body_color

  def year_shamsi
    self.year.year if self.year
  end

  def year_miladi
    self.year.year if self.year
  end

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
    ads = ads.where(status: 2) 
    ads = ads.where(car_model_id: self.car_model_id)
    ads = ads.where.not(id: self.id)
    ads = ads.where("updated_at > ?", 10.days.ago)
    ads = ads.order("RANDOM()")
    ads = ads.limit(count)
    if ads.size < 4
      ids = (ads.ids << self.id)
      ads2 = Ad.where(make_id: self.make_id)
      ads2 = ads2.where.not(id: ids)
      ads2 = ads2.where("updated_at > ?", 10.days.ago)
      ads2 = ads2.order("RANDOM()")
      ads2 = ads2.limit(count - ads.size)
      ads = ads.concat ads2
    end
    ads
  end

  def city
    self.location.split( ",").first if self.location
  end

  def big_images
    self.user_id.nil? ? self.image_urls : self.images
  end

  def thumb_images
    self.user_id.nil? ? self.image_urls : self.images
  end

  def image_upload_disabled
    self.images.size >= 8 ? true  : false
  end

  def view_counter_increment current_user
    unless self.user == current_user
      self.ad_other_field.viewed = self.ad_other_field.viewed + 1
      self.ad_other_field.save
    end
  end

  def status_human
    case self.status
    when 0
      "incomplete"
    when 1
      "not_verified"
    when 2
      "actived"
    when 30 
      "info_problem rejected"
    when 31
      "image_problem rejected"
    when 32
      "tel_problem rejected"
    when 40
      "sold" 
    when 50
      "expired"
    end
  end

  def status_human_short
    case self.status
    when 0
      "incomplete"
    when 1
      "not_verified"
    when 2
      "actived"
    when 30 , 31,32
      "rejected"
    when 40
      "sold" 
    when 50
      "expired"
    end
  end

  def updated_times_decrement
    if self.ad_other_field.updated_times > 0
      self.touch
      self.ad_other_field.updated_times = self.ad_other_field.updated_times - 1
      self.save
    end
  end

  def verifying code
    self.status = code.to_i
    self.save
  end

private

end
