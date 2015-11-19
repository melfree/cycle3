class HomeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "home_#{current_user.id}"
  end
end
