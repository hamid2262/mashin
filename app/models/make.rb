class Make < ActiveRecord::Base
  has_many :car_models
  has_many :ads
end