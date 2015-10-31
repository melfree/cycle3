class HomeController < ApplicationController
  def index
    @users = User.all
  end
  
  def edit_status
    current_user.location = params[:user][:location]
    current_user.status = params[:user][:status]
    current_user.save!
  end
end
