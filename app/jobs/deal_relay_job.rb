class DealRelayJob < ApplicationJob
  def perform(user)
    ActionCable.server.broadcast "deals_#{user.id}", {
        in_progress: !user.current_deal_id.nil?,
        
        current_user_status_html: HomeController.render(partial: 'deals/match_alerts', locals: { user: user }),
        chatroom_html: HomeController.render(partial: 'deals/chatroom', locals: { user: user }),
        match_user_html: HomeController.render(partial: 'deals/match_user', locals: { user: user }),
        match_user_status_html: HomeController.render(partial: 'deals/match_user_status', locals: { user: user }),
        meta_html: HomeController.render(partial: 'layouts/meta', locals: { user: user })
      }
  end
end