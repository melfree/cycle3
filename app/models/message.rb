class Message < ActiveRecord::Base
  belongs_to :deal
  belongs_to :user
  
  validates_presence_of :content
  
  after_commit :relay_job
  
  private
  def relay_job
    self.deal.relay_job
  end
end
