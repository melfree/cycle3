class MatchRelayJob < ApplicationJob
  def perform(user)
    ActionCable.server.broadcast "match_#{user.id}", {
      html: HomeController.render(partial: 'home/match', locals: { user: user })
    }
    ActionCable.server.broadcast "match_#{user.matched_user.id}", {
      html: HomeController.render(partial: 'home/match', locals: { user: user.matched_user })
    }
  end
end