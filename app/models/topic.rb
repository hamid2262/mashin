class Topic < ActiveRecord::Base
  has_many :articles

  validates :slug, presence: true, uniqueness: true
  
  def to_param
    slug
  end

end
