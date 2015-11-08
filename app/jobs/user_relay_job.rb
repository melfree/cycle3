class UserRelayJob < ApplicationJob
  def perform(user)    
    ActionCable.server.broadcast "home",
      {key_id: user.id,
        no_matched_user: user.matched_user.nil?,
        is_seller: user.is_seller,
        is_buyer: user.is_buyer,
        is_unavailable: user.is_unavailable,
        html: html(user),
        html_matched_user: html_matched_user(user),
        html_google_map: html_google_map
      }
  end
  
  private
  def html(user)
    if !user.is_unavailable
      HomeController.render(partial: 'users/user', locals: { user: user })
    else
      'Placeholder'
    end
  end
  
  def html_matched_user(user)
    HomeController.render(partial: 'home/match', locals: { user: user })
  end
  
  def html_google_map
    HomeController.render(partial: 'home/google_map', locals: { users: User.active })
  end
end