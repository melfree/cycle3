class UserRelayJob < ApplicationJob
  def perform(user)
    ActionCable.server.broadcast "home",
      {key_id: user.id,
        key: 'data-user-id',
        is_seller: user.is_seller,
        is_buyer: user.is_buyer,
        is_unavailable: user.is_unavailable,
        html: html(user)
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
end