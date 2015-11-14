class Deal < ActiveRecord::Base
  has_many :messages
  
  STATUSES = ["Pending - Deal in Progress",
              "Completed - Deal was Successfully Finished",
              "Cancelled - Deal was Cancelled"]
  
  CSS_CLASSES = ["pending","completed","cancelled"]
  
  def allow_comments
    !buyer_finished and !seller_finished
  end
  
  def buyer_css_class
    CSS_CLASSES[self.buyer_status_code.to_i]
  end
  
  def seller_css_class
    CSS_CLASSES[self.seller_status_code.to_i]
  end
  
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
    STATUSES[self.buyer_status_code.to_i]
  end
  
  def seller_status_name
    STATUSES[self.seller_status_code.to_i]
  end
  
  before_update :set_finished_timestamps
  # Runs after create or update.
  after_update :relay_job
  
  def relay_job
    # A seller should get updates for their deal only if they are still associated with the deal.
    # After that, the seller should not be updated about the deal
    if seller_attached_to_deal
      seller.finish_deal if seller_finished
      DealRelayJob.perform_later(seller)
    end
    if buyer_attached_to_deal
      buyer.finish_deal if buyer_finished
      DealRelayJob.perform_later(buyer)
    end
  end
  
  def seller
    @seller ||= User.find_by_id seller_id
  end
  
  def buyer
    @buyer ||= User.find_by_id buyer_id
  end
    
  private
  def buyer_attached_to_deal
    # A buyer and a seller are "attached" to this deal
    # if this deal is their current deal, and they are still listening
    # for changes in this deal on their homepage.
    self.buyer.current_deal_id == self.id
  end
  
  def seller_attached_to_deal
    self.seller.current_deal_id == self.id
  end
  
  def set_finished_timestamps
    if buyer_finished_at.nil? and buyer_finished
      self.buyer_finished_at = Time.now
    end
    if seller_finished_at.nil? and seller_finished
      self.seller_finished_at = Time.now
    end
  end
end
