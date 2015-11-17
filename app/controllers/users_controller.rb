class UsersController < ApplicationController
  def index
    @users = User.all
    @deals = Deal.all
  end

  def edit_current_user
    current_user.update_attributes!(current_user_params)
  end
  
  # Current location is updated automatically on page load via javascript.
  def edit_current_location
    current_user.update_attributes!(current_location_params)
  end

  def show
    @user = User.find(params[:id])
  end
  
  private
  def current_user_params
    params.required(:user).permit(:status_code,:meal_plan_code,:description)
  end
  
  def current_location_params
    params.required(:location).permit(:longitude,:latitude)
  end
end
