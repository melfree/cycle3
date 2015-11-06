class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:guest]
  
  def index
    @users = User.active
  end
  
  def guest
  end
end
