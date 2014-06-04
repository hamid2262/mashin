class Make < ActiveRecord::Base
  has_many :car_models
  has_many :ads

  scope :visible, -> { where(visible: true) }
  scope :sorted, -> { order(name: :asc) }

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
    arr = self.car_models.select(:deligate).map(&:deligate).uniq
    CarModel.where(id: arr).order(name: :asc) 
  end

  def self.find_makes
    makes = Make.select("makes.deligate").group(:deligate)
    makes = makes.map{|m| m.deligate}
    Make.where(id: makes).includes(:car_models).order(:name)
  end
end