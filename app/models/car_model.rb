class CarModel < ActiveRecord::Base
  belongs_to :make
  has_many :ads
  # default_scope { visible.order('name') }

  scope :visible, -> { where(visible: true) }

end
