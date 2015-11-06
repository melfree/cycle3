class HomeChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "home"
  end
end
