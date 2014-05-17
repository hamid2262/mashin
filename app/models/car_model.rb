class CarModel < ActiveRecord::Base
  belongs_to :make
  has_many :ads
  default_scope { order('name') }
end
