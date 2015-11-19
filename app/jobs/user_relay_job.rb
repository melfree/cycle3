class UserRelayJob < ApplicationJob
  def perform
    users = User.active
    ActionCable.server.broadcast "users",
      { sellers_html: HomeController.render(partial: 'users/users',
                                          locals: {data_channel: "sellers", users: users.sellers}),
        buyers_html: HomeController.render(partial: 'users/users',
                                          locals: {data_channel: "buyers", users: users.buyers}),
        html_google_map: HomeController.render(partial: 'users/google_map',
                                               locals: { users: users })
      }
  end
end