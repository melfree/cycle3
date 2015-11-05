class DealsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "deals"
  end
end
