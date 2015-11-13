class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:guest]

  def guest
  end
end
