class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  check_authorization :unless => :devise_controller?
  before_action :get_user_informations
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def get_user_informations
    unless session[:guest_user_country]
      session[:guest_user_country] = request.try(:location).try(:country)
      session[:guest_user_city]    = request.try(:location).try(:city)
    end
    session[:user_ip] = request.try(:location).try(:ip) unless session[:user_ip]
# raise
    req = request.try(:referer)
    if req        
      unless (req.include? "http://www.otoyabi." or req.include? "http://otoyabi.")
        session[:user_referer] = req   
      end
    end
  end

end
