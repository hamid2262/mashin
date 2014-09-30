class CarModel < ActiveRecord::Base
  belongs_to :make
  has_many :ads
  has_many :built_years

  scope :visible, -> { where(visible: true) }

  def to_param
    "#{id}-#{fa_parametrize(self.make.name)}-#{fa_parametrize(self.name)}"
  end

  def deligate_obj
    if self.deligate   
      CarModel.find self.deligate 
    else
      self
    end
  end  

  def active_ads
    self.ads.where(status: 2).order("updated_at DESC")
  end

  def ads
    @ads ||= find_ads
  end

private
  def find_ads
    ads = Ad.all.includes(:car_model, car_model: :make)
    ads = ads.order("updated_at DESC") 
    conditions ads
  end


  def conditions values
    values = values.where("status = 2") 
    values = values.where( ads:{ car_model_id: find_car_model_deligates } )
    values
  end

  def find_car_model_deligates
    car_model = CarModel.find self.id
    CarModel.where(deligate: car_model.deligate).ids
  end

  def fa_parametrize val
    val.gsub(' ', '-')  if val
  end

end
