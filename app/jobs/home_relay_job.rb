class HomeRelayJob < ApplicationJob
  def perform(user)
    ActionCable.server.broadcast "home",
      {key_id: user.id,
        is_deal: false,
      key: 'data-user-id',
      is_seller: user.is_seller,
      is_buyer: user.is_buyer,
      html: HomeController.render(partial: 'users/user', locals: { user: user })
      }
  end
end