class HomeController < ApplicationController
  def index
    @users = User.all
  end
  
  def edit_status
    current_user.location = params[:location]
    current_user.status = params[:status]
    current_user.save!
  end
end
