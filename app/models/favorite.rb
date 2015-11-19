class Favorite < ActiveRecord::Base
  belongs_to :favoriter, class_name: "User", foreign_key: "favoriter_id"
  belongs_to :favorited, class_name: "User", foreign_key: "favorited_id"
  
  validates_presence_of :favorited, :favoriter
  
  validate :unique_check
  
  after_commit :relay_job
  
  private
  def unique_check
    if Favorite.where(favoriter_id: favoriter_id, favorited_id: favorited_id).count > 0
      errors.add(:base,"You already favorited this user")
    end
  end
  
  def relay_job
    UserRelayJob.perform_later()
    DealRelayJob.perform_later(favoriter)
    DealRelayJob.perform_later(favorited)
  end
end
