class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  geocoded_by :location
  after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }
  
  def is_admin?
    true if self.admin? || self.email == 'hamid2262@yahoo.com'  
  end

  def name
    if self.first_name.present? || self.last_name.present?
      self.try(:first_name).try(:titleize) + " "+ self.try(:last_name).try(:titleize)
    else      
      self.email.partition("@").first 
   end
  end
  
end
