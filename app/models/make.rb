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

end