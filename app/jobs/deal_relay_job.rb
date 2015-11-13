class DealRelayJob < ApplicationJob
  def perform(user)
    ActionCable.server.broadcast "deals_#{user.id}", {
        html: HomeController.render(partial: 'deals/match', locals: { user: user })
      }
  end
end