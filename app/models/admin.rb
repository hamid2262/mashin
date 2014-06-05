class Admin

  def searches
    Search.order(created_at: :desc)
  end

  def users
    User.order(created_at: :desc)
  end

end 