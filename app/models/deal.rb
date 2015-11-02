class Deal < ActiveRecord::Base
  def seller
    User.find_by_id self.seller_id
  end
  def buyer
    User.find_by_id self.buyer_id
  end
  
  def owner
    return seller if seller
    buyer
  end
  def is_sale
    self.status.to_i == 1
  end
  def is_purchase
    [2,3,4].include?(self.status.to_i)
  end
  def is_complete
    self.status.to_i.zero? or destroyed?
  end
  
  def owns(sym)
    return false unless User::MEAL_PLAN_ELEMENTS.include?(sym)
    self.public_send(sym) > 0
  end
  
  def status_and_location
    if status and location
      "#{status_name} at #{location_name}, at #{time || "anytime"}"
    elsif status
      "#{status_name}, at #{time || "anytime"}"
    else
      STATUSES[0]
    end
  end
  def status_name
    STATUSES[self.status.to_i]
  end
  def location_name
    User::LOCATIONS[self.location.to_i]
  end
  def status_class
    if is_purchase
      "buyer"
    elsif is_sale
      "seller"
    end
  end
  
  scope :active, -> { where("status <> 0")}
  scope :sales, -> { where(status: 1)}
  scope :purchases, -> { where("status in (2,3,4)")}
  
  def self.select_options_for_status
    STATUSES.map.with_index.to_a.drop(1)
  end
  STATUSES = ["Completed",
              "Sale, seeking buyer",
              "Want-to-buy, seeking any seller",
              "Want-to-buy (blocks only)",
              "Want-to-buy (Dinex/Flex only)"]
    
  # Real-time data
  # Runs after create, update, or destroy
  after_save :relay_job
  before_destroy :destroy_relay_job
    
  private
  def destroy_relay_job
    self.update_attribute(:status, 0)
    # Perform this job now, while the object still exists
    DealRelayJob.perform_now(self)
  end
  
  def relay_job
    DealRelayJob.perform_later(self)
  end
end
