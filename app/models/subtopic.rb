class Subtopic < ActiveRecord::Base
  belongs_to :topic
  has_many   :articles
  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end

  def deligate_obj
    Subtopic.find_by id: self.deligate
  end

end
