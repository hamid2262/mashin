class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 
    if user.is_admin?
      can :manage, :all
    elsif user.try(:email) != ""
      ####  signed in users
      can [:show, :edit, :update], User do |u|
        user == u
      end
      
      can [:new, :create, :edit, :update, :show, :destroy, :index], Image

      can [:show, :new, :create], Ad
      can [:destroy], Ad do |ad|
        ad.user == user
      end
      can [:edit, :update], Ad do |ad|
        (ad.status < 3) && (ad.user == user) 
      end

    else
      ####  Guest users
      can [:new, :create], User
    end
      
    can [:new, :create, :show], Search
    can :read, Home
    can :show, Ad
  end

end
