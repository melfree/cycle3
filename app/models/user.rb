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
  
  scope :active, ->  { where("status <> 0")}
  scope :sellers, -> { where(status: 1)}
  scope :buyers, -> { where("status in (2,3,4)")}
  scope :finding_match, -> { where(find_match: true) }
  
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
    self.status.to_i == 0
  end
  
  def is_seller
    self.status.to_i == 1
  end
  
  def is_buyer
    [2,3,4].include?(self.status)
  end
  
  def status_class
    if is_buyer
      "buyer"
    elsif is_seller
      "seller"
    end
  end
  
  def status_and_location
    #if status and location
    #  "#{status_name} at #{location_name}"
    #else
    #  status_name
    #end
    # We are ignoring location_name in users for the time being.
    status_name
  end
  
  def status_name
    statuses = STATUSES.values.flatten(1)
    statuses[self.status.to_i][0]
  end
  STATUSES = {'N/A' => [["I am not available",0]],
              'Seller' => [["I want to sell my Meal Plan",1]],
              'Buyer' =>  [["I want to buy any Blocks, Dinex, or Flex",2],
                           ["I want to buy Blocks only",3],
                           ["I want to buy Dinex/Flex only",4]]
              }
  
  def location_name
    LOCATIONS[self.location.to_i]
  end
  LOCATIONS = ["Upper CUC",
               "Lower CUC",
               "Entropy",
               "Wean Hall"]
  
  def owns(sym)
    return false unless MEAL_PLAN_ELEMENTS.include?(sym)
    self.public_send(sym) > 0
  end
  
  def owns_meal_plan
    MEAL_PLAN_ELEMENTS.inject(false) {|mem,sym| self.owns(sym) || mem}
  end
  MEAL_PLAN_ELEMENTS = [:blocks,:guest_blocks,:dinex]
  
  def matched_user
    if self.matched_user_id
      User.find_by_id(self.matched_user_id)
    else
      nil
    end
  end
  
  # Real-time data
  after_commit :relay_job
  before_save :match_user
    
  private
  def match_user
    # If we are currently looking for a user, and we're a buyer/seller,
    # BUT haven't started the search yet,
    # try to match with another user.
    if find_match and !(self.is_unavailable) and self.find_match_start_time.nil?
      match = if user.is_buyer
        User.finding_match.sellers.least_recent
      else
        User.finding_match.buyers.least_recent
      end
      if match
        # We found a matching buyer/seller.
        self.find_match = false
        self.matched_user_id = match.id
        match.find_match = false
        match.find_match_start_time = nil
        match.matched_user_id = self.id
        match.save!
      else
        # No match found. Remember when this user started looking for a match.
        set_match_start_time
      end
    end
  end
    
  def least_recent
    order(:find_match_start_time).first
  end
  
  def set_match_start_time
    self.find_match_start_time = Time.now
  end
  
  def relay_job
    # Update the views.
    UserRelayJob.perform_later(self)
  end
end