class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  check_authorization :unless => :devise_controller?
  # before_action :get_user_informations
  before_action :redirect_from_otoyabi_dot_ir
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  helper_method :fa_parametrize
  def fa_parametrize val
    val.gsub(' ', '-')  if val
  end

  helper_method :makes_list
  def makes_list
    makes = Make.where("makes.id = deligate").joins(:ads).group(['makes.id'])
    makes.order('COUNT(ads.make_id) DESC').count
  end

private
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

  def redirect_from_otoyabi_dot_ir
    url = request.url
    if url.include? "otoyabi.ir"
      new_url = url.sub "otoyabi.ir", "otoyabi.com"
      redirect_to new_url
    end
  end
end
