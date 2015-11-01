class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  # Devise strong parameters
  def configure_permitted_parameters
    permittable_params = [:email,:name,:password,:password_confirmation,:current_password]
        
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(*permittable_params)
    end
    
    # A User has a lot of params that Deals also has, except for time, seller, and buyer.
    permittable_params += deal_params - [time,seller_id,buyer_id]
    
    #permit photo coordinates for when adjusting the photo
    permittable_params += [:photo_crop_x, :photo_crop_y, :photo_crop_w, :photo_crop_h]

    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(*permittable_params)
    end
  end
  
  def deal_params
    [:dinex,:blocks,:guest_blocks,:photo,:description,:status,:location,time,seller_id,buyer_id]
  end 
end
