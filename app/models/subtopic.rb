class Subtopic < ActiveRecord::Base
  belongs_to :topic
  has_many   :articles

  def to_param
    slug
  end

  def deligate_obj
    Subtopic.find_by id: self.deligate
  end

end
