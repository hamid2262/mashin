class Topic < ActiveRecord::Base
  has_many :articles
  has_many :subtopics

  validates :slug, presence: true, uniqueness: true
  scope :menus, -> { where("id = deligate") }  
  scope :ordered, -> { order(order: :asc) }  
  
  def to_param
    slug
  end

  def same_topic_articles
    Article.where(topic_id: sisters.ids)
  end

  def sisters
    Topic.where(deligate: self.deligate)
  end

  def deligate_obj
    Topic.find_by id: self.deligate
  end

end
