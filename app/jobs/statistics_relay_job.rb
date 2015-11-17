class StatisticsRelayJob < ApplicationJob
  def perform   
    ActionCable.server.broadcast "users",
      {statistics_html: UsersController.render(partial: 'users/statistics',
                                              locals: { users: User.all,
                                                        deals: Deal.all
                                                        })
      }
  end
end