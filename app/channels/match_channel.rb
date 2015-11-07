class MatchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "match_#{current_user.id}"
  end
end
