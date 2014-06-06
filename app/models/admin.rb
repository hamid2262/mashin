class Admin
  
  def searches user_ip
    if user_ip
      Search.where(user_ip: user_ip).order(created_at: :desc)      
    else
      Search.order(created_at: :desc)      
    end
  end

  def users
    User.order(created_at: :desc)
  end

  def unverified_ads
    Ad.where("status < 2").limit(20)
  end

end 