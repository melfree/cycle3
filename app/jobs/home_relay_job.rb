class HomeRelayJob < ApplicationJob
  def perform(user)
    ActionCable.server.broadcast "home",
      {user_id: user.id,
      is_seller: user.is_seller,
      is_buyer: user.is_buyer,
       user: HomeController.render(partial: 'users/user', locals: { user: user })
      }
  end
end