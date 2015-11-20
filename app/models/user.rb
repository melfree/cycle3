class User < ActiveRecord::Base
  has_many :purchases, class_name: "Deal", foreign_key: 'buyer_id'
  has_many :sales, class_name: "Deal", foreign_key: 'seller_id'
  has_many :favorites, foreign_key: 'favoriter_id'
  has_many :favorited, class_name: "Favorite", foreign_key: 'favorited_id'
  
  validates_presence_of :email
  # require edu email
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+\.edu\z/, message: "must end with.edu"
  
  # Photo uploader dependencies
  mount_uploader :photo, PhotoUploader
  crop_uploaded :photo
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
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
  
  MEAL_PLANS = ["Blocks and Dinex/Flex",
                "Dinex/Flex",
                "Blocks"]
  
  def status_text
    if is_unavailable
      "Not currently searching for a new match."
    elsif is_searching
      "Currently searching for a new match. There are currently no available users. Waiting for an available user."
    elsif current_deal_id and current_deal.at_least_one_user_finished
      "The other user has left your current match."
    else
      "Matching user found. Details are shown on your dashboard."
    end
  end
  
  def status_css
    if is_unavailable
      "warning"
    elsif is_searching
      "info"
    elsif current_deal_id and current_deal.at_least_one_user_finished
      "warning"
    else
      "success"
    end
  end
  
  def favoriter_ids
    # the stringified ids of the users that favorited this user
    self.favorited.pluck(:favoriter_id).map{|o|o.to_s}
  end
  
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
  
  # MANUAL MATCH METHOD, guaranteed to match any available user with available buyer/seller
  def manual_match_user(match_user)
  #   # IF match_user is a seller, self will become a buyer
      # ELSE match_user is a buyer, so self must become a seller
    raise "Error: can't match because match_user is not a buyer or seller, or is in a deal already" unless match_user.is_searching
    raise "Error: can't match because current_user is in a deal already" unless self.current_deal_id.nil?

    if match_user.is_buyer
      seller = self
      buyer = match_user
      seller.meal_plan_code = buyer.meal_plan_code
      seller.status_code = 1
    
    elsif match_user.is_seller
      seller = match_user
      buyer = self
      buyer.meal_plan_code = seller.meal_plan_code
      buyer.status_code = 2
    end
    
    match(buyer,seller)

    # Save changes made to 'self' only; match(buyer,seller) saves other changes made.
    self.save!
  end

  private
  
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
        match(buyer,seller)
      else
        # No match found. Remember when this user started looking for a match.
        self.search_start_time = Time.now
      end
    else
      self.search_start_time = nil
    end
  end

  def match(buyer, seller)
        # Requires that self is the buyer or seller
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
  end
  
  def relay_job
    # Update the views.
    UserRelayJob.perform_later()
    DealRelayJob.perform_later(self)
    StatisticsRelayJob.perform_later()
  end
end
