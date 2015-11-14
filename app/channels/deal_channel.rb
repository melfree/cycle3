class DealChannel < ApplicationCable::Channel
  def subscribed
    stream_from "deals_#{current_user.id}"
  end
end
