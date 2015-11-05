class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:guest]
  
  def index
    @users = User.active
  end
  
  def edit_status
    current_user.update_attributes!(current_user_params)
  end
  
  def guest
  end
  
  private
  def current_user_params
    params.required(:user).permit(:location,:status,:dinex,:blocks,:guest_blocks,:description)
  end
end
