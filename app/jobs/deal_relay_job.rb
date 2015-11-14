class DealRelayJob < ApplicationJob
  def perform(user)
    ActionCable.server.broadcast "deals_#{user.id}", {
        chatroom_html: HomeController.render(partial: 'deals/chatroom', locals: { user: user }),
        match_user_html: HomeController.render(partial: 'deals/match_user', locals: { user: user })
      }
  end
end