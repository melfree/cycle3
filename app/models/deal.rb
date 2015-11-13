class Deal < ActiveRecord::Base
  belongs_to :seller, foreign_key: "seller_id", class_name: "User"
  belongs_to :buyer, foreign_key: "buyer_id", class_name: "User"
  
  STATUSES = ["Pending - Deal in Progress",
              "Completed - Deal was Successfully Finished",
              "Cancelled - Deal was Cancelled"]

  # These flags are used with DealRelayJob, to indicate when to update data streams.
  attr_accessor :buyer_just_ended_flag, :seller_just_ended_flag

  def buyer_finished
    buyer_status_code.to_i != 0
  end
  
  def seller_finished
    seller_status_code.to_i != 0
  end
  
  def self.status_options
    STATUSES.each_with_index.map{|o,i| [o,i]}
  end
  
  def buyer_status_name
    STATUSES[self.seller_status_code.to_i]
  end
  
  def seller_status_name
    STATUSES[self.buyer_status_code.to_i]
  end
  
  before_update :set_finished
  # Runs after create or update.
  after_save :relay_job
    
  private
  def relay_job
    DealRelayJob.perform_later(self)
  end
  
  def set_finished
    if buyer_finished_at.nil? and buyer_finished
      buyer.finish_deal
      self.buyer_finished_at = Time.now
    end
    if seller_finished_at.nil? and seller_finished
      seller.finish_deal
      self.seller_finished_at = Time.now
    end
  end
end
