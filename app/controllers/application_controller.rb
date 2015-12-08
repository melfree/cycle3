class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_filter :check_device

  protected
  
  # Devise strong parameters
  def configure_permitted_parameters
    permittable_params = [:notify_by_email,:friends_only,:photo,:email,:description,:name,:password,:password_confirmation,:current_password]
        
    #permit photo coordinates for when adjusting the photo
    permittable_params += [:photo_crop_x, :photo_crop_y, :photo_crop_w, :photo_crop_h]

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(*permittable_params)
    end
    
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(*permittable_params)
    end
  end

  def check_device
    $device_type = "non-mobile"
    if !request.env['HTTP_USER_AGENT'].nil? 
      if request.env['HTTP_USER_AGENT'].downcase.match(/ipad|ipod|iphone/) 
        $device_type = "iOS"
      elsif request.env['HTTP_USER_AGENT'].downcase.match(/android/) 
        $device_type = "android"
      end
    end
  end

end
