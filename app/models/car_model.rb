class CarModel < ActiveRecord::Base
  belongs_to :make
  has_many :ads
  has_many :built_years

  scope :visible, -> { where(visible: true) }

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

end
