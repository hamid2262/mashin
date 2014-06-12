class Topic < ActiveRecord::Base
  has_many :articles

  def last_articles
    self.articles.order(:updated_at).limit(50)
  end
end
