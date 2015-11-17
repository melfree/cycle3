class User < ActiveRecord::Base
  has_many :purchases, class_name: "Deal", foreign_key: 'buyer_id'
  has_many :sales, class_name: "Deal", foreign_key: 'seller_id'
  
  validates_presence_of :email
  
  # Photo uploader dependencies
  mount_uploader :photo, PhotoUploader
  crop_uploaded :photo
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  scope :inactive, ->  { where(status_code: 0)}
  scope :active, ->  { where("status_code <> 0")}
  scope :not_including, -> (user) {where("id <> ?",user.id)}
  
  # Meal plan code of 0 means that everyone is included.
  # Meal plan code of 1 or 2 must be matched exactly, or to anyone with 0.
  scope :meal_plan_code, ->(code) { where("meal_plan_code = 0 OR meal_plan_code = ? OR ? = 0", code,code) }
  scope :sellers, -> { where(status_code: 1)}
  scope :buyers, -> { where(status_code: 2)}
  
  scope :searching, -> { where(current_deal_id: nil) }
  
  USER_STATUSES = ["Not Seeking Deal",
                   "Seller - Seeking Buyer",
                   "Buyer - Seeking Seller"]
  
  MEAL_PLANS = ["Blocks",
                "Dinex/Flex",
                "Blocks and Dinex/Flex"]
  
  def self.meal_plan_options
    MEAL_PLANS.each_with_index.map{|o,i| [o,i]}
  end
  
  def self.status_options
    USER_STATUSES.each_with_index.map{|o,i| [o,i]}
  end
  
  def photo_url
    if photo.blank?
      "http://placehold.it/100x100"
    else
      photo.url(:thumb)
    end 
  end
  
  def small_photo_url
    if photo.blank?
      "http://placehold.it/50x50"
    else
      photo.url(:small_thumb)
    end 
  end
  
  def is_unavailable
    status_code.to_i == 0
  end
  
  def is_seller
    status_code.to_i == 1
  end
  
  def is_buyer
    status_code.to_i == 2
  end
  
  def is_searching
    (is_seller or is_buyer) and current_deal_id.nil?
  end
  
  def searching_name
    if is_searching
      "Searching for Deal"
    else
      "Deal Found"
    end
  end
  
  def status_name
    USER_STATUSES[self.status_code.to_i]
  end
  
  def meal_plan_name
    buying_or_selling = if is_buyer
      "Buying"
    else
      "Selling"
    end
    "#{MEAL_PLANS[self.meal_plan_code.to_i]}"
  end
  
  # Real-time data
  after_commit :relay_job
  before_update :match_user
  
  def current_deal
    @current_deal ||= if current_deal_id
      Deal.find_by_id current_deal_id
    else
      nil
    end
  end
  
  def deal_status_attribute
    if is_buyer
      :buyer_status_code
    else
      :seller_status_code
    end
  end
  
  def finish_deal
    self.current_deal_id = nil
    self.status_code = 0
    self.save!
  end
  
  private

  # def manual_match_user
  #   #code taken from match user
  #   if is_buyer
  #     #seller = [user from _users.html.erb]
  #   else
  #     #buyer = [user from _users.html.erb]
  #   end
  #     deal = Deal.create!(seller_id: seller.id, buyer_id: buyer.id)
  #     buyer.current_deal_id = deal.id
  #     seller.current_deal_id = deal.id
  #     # Save the matched user here, so there is no recursion with 'before_save'.
  #     if is_buyer
  #       seller.save!
  #       DealRelayJob.perform_later(seller)
  #     else
  #       buyer.save!
  #       DealRelayJob.perform_later(buyer)
  #     end
  # end

  def match_user
    if is_searching
      # Find a new matching user
      scope = User.searching.meal_plan_code(self.meal_plan_code).not_including(self).order(:search_start_time)
      if is_buyer
        seller = scope.sellers.first
        buyer = self
      else
        buyer = scope.buyers.first
        seller = self
      end
      if buyer and seller # We found a matching buyer/seller. Create the deal.
        deal = Deal.create!(seller_id: seller.id, buyer_id: buyer.id)
        buyer.current_deal_id = deal.id
        seller.current_deal_id = deal.id
        # Save the matched user here, so there is no recursion with 'before_save'.
        if is_buyer
          seller.save!
          DealRelayJob.perform_later(seller)
        else
          buyer.save!
          DealRelayJob.perform_later(buyer)
        end
      else
        # No match found. Remember when this user started looking for a match.
        self.search_start_time = Time.now
      end
    else
      self.search_start_time = nil
    end
  end
  
  def relay_job
    # Update the views.
    UserRelayJob.perform_later(self)
    DealRelayJob.perform_later(self)
    StatisticsRelayJob.perform_later()
  end
end
