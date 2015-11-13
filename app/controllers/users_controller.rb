class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def edit_current_user
    current_user.update_attributes!(current_user_params)
  end

  def show
    @user = User.find(params[:id])
  end
  
  private
  def current_user_params
    params.required(:user).permit(:status_code,:meal_plan_code,:longitude,:latitude,:description)
  end
end
