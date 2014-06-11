class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  check_authorization :unless => :devise_controller?
  before_action :get_user_informations
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

private
  def set_topic
    # @topic = Topic.find(params[:id])
    @topic = Topic.find_by!(subdomain: request.subdomain)
  end

  def get_user_informations
    # unless session[:guest_user_country]
    #   session[:guest_user_country] = request.try(:location).try(:country)
    #   session[:guest_user_country] = session[:guest_user_country][0,50] if session[:guest_user_country]
    #   session[:guest_user_city]    = request.try(:location).try(:city)
    #   session[:guest_user_city]    = session[:guest_user_city][0,50] if session[:guest_user_city]
    # end
    
    # unless session[:user_ip]
    #   session[:user_ip] = request.try(:location).try(:ip) 
    #   session[:user_ip] = session[:user_ip][0,50] if session[:user_ip]
    # end
    # req = request.try(:referer)
    # if req        
    #   unless (req.include? "http://www.otoyabi." or req.include? "http://otoyabi.")
    #     session[:user_referer] = req[0,250] if session[:user_referer]
    #   end
    # end
  end

end
