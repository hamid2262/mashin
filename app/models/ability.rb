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

      can [:show], Dashboard

      #######  Ad
      can [:show, :new, :create], Ad
      can [:destroy], Ad do |ad|
        ad.user == user
      end

      can [:sold], Ad do |ad|
        ad.user == user and ad.status == 2
      end

      can [:edit, :update], Ad do |ad|
        ad.user == user and  [0, 1, 2, 30,31,32, 5].include?(ad.status) and ad.ad_other_field.updated_times > 0
      end

      can [:touch], Ad do |ad|
        ad.user == user and ad.ad_other_field.updated_times > 0 and ad.status == 2
      end
      #######

      can [:new, :create, :edit, :update, :show, :destroy, :index], Image do |img|
        img.ad.user == user
      end

    else
      ####  Guest users
      can [:new, :create], User
    end
      
    can [:new, :create, :show, :index, :ajax], Search
    can :read, Home
    can :show, Ad
    can :show, Article
  end

end
