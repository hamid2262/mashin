class Dashboard 

  def initialize user
    @user = user      
  end
  
  def my_ads
    @user.ads.order("updated_at DESC")
  end

  def timeline
    Shout.where(user_id: shout_user_ids).includes(:user).includes(:content)
  end


end