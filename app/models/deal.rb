class Deal < ActiveRecord::Base
  has_one :seller, class_name: "User", foreign_key: "seller_id"
  has_one :buyer, class_name: "User", foreign_key: "buyer_id"
  
  def is_sale
    self.status.to_i == 1
  end
  def is_purchase
    [2,3,4].include?(self.status.to_i)
  end
  
  def owns(sym)
    return false unless User::MEAL_PLAN_ELEMENTS.include?(sym)
    self.public_send(sym) > 0
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
  after_commit :relay_job
    
  private
  def relay_job
    DealRelayJob.perform_later(self)
  end
end
