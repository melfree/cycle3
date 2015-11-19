class UserRelayJob < ApplicationJob
  def perform
    users = User.active
    ActionCable.server.broadcast "users",
      { users_html: HomeController.render(partial: 'users/users',
                                          locals: {users: users}),
        html_google_map: HomeController.render(partial: 'users/google_map',
                                               locals: { users: users })
      }
  end
end