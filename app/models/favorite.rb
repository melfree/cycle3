class Favorite < ActiveRecord::Base
  #relationships
  belongs_to :user

  #callback
  before_save :get_favorited

  def get_favorited
    self.user_id = current_user.id #id of the person favoriting
    self.user_name = current_user.name
    self.user_email = current_user.email
  end

end
