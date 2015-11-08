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
    params.required(:user).permit(:find_match,:find_match_in_progress,:location,:longitude,:latitude,:status,:dinex,:blocks,:guest_blocks,:description)
  end
end
