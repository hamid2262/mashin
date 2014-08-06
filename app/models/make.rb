class Make < ActiveRecord::Base
  has_many :car_models
  has_many :ads

  scope :visible, -> { where(visible: true) }
  scope :sorted, -> { order(name: :asc) }
  
  def to_param    
    slug
  end

  def self.make_id(name)
    Rails.cache.fetch([:make, name, :id], expires_in: 15.hours) do 
      Make.find_by(name: name).id
    end
  end

  def self.for_menus
    @makes ||= find_makes
  end

  def deligated_car_models
    @car_models ||= find_car_models
  end

private
  def find_car_models
     self.car_models.where("id = deligate").order(name: :asc) 
  end

  def self.find_makes
    Make.where("id = deligate").order(name: :asc) 
  end
end