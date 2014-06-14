class Topic < ActiveRecord::Base
  has_many :articles

  validates :slug, presence: true, uniqueness: true
  
  def to_param
    slug
  end

  def last_articles
    self.articles.order(updated_at: :desc).limit(50)
  end


end
