class Admin
  
  def searches
    Search.order(created_at: :desc)
  end

  def users
    User.order(created_at: :desc)
  end

  def unverified_ads
    Ad.where("status < 2").limit(20)
  end

end 