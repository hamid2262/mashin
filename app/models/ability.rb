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
      
      can [:show, :new, :create], Ad
      can [:edit, :update, :destroy], Ad do |ad|
        ad.user = user
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