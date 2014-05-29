class Image < ActiveRecord::Base

  has_attached_file :name, :styles => { :medium => "440x300#", :thumb => "120x90#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :name, :content_type => /\Aimage\/.*\Z/

  belongs_to :ad

  validates :name, presence: true
  validates :ad_id, presence: true
  
  validate :max_image_size

  private
  def max_image_size
    errors.add(:base, 'تعداد تصویر بیش از این مقدور نیست') if self.ad.images.size >= 8 
  end
end
