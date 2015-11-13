class UserRelayJob < ApplicationJob
  def perform(user)    
    ActionCable.server.broadcast "users",
      {key_id: user.id,
        is_searching: user.is_searching,
        is_seller: user.is_seller,
        is_buyer: user.is_buyer,
        is_unavailable: user.is_unavailable,
        html: html(user),
        html_google_map: html_google_map
      }
  end
  
  private
  def html(user)
    HomeController.render(partial: 'users/user', locals: { user: user })
  end
  
  def html_google_map
    HomeController.render(partial: 'users/google_map', locals: { users: User.active })
  end
end