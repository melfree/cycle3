class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:email,:name,:dinex,:blocks ,:guest_blocks,:photo,:description,:location,:password,:password_confirmation,:current_password,:photo_crop_x, :photo_crop_y, :photo_crop_w, :photo_crop_h)}
  end
end
