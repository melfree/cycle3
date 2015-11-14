class UserChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "users"
  end
end
