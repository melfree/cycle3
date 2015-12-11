class UserRelayJob < ApplicationJob
  def perform
    users = User.active
    ActionCable.server.broadcast "users",
      { sellers_html: HomeController.render(partial: 'users/users',
                                          locals: {data_channel: "sellers", users: users.sellers.unmatched_first}),
        buyers_html: HomeController.render(partial: 'users/users',
                                          locals: {data_channel: "buyers", users: users.buyers.unmatched_first}),
        html_google_map: HomeController.render(partial: 'users/google_map',
                                               locals: { users: users })
      }
  end
end