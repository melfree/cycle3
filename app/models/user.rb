class User < ActiveRecord::Base
  has_many :purchases, class_name: "Deal", foreign_key: 'buyer_id'
  has_many :sales, class_name: "Deal", foreign_key: 'seller_id'
  has_many :favorites, foreign_key: 'favoriter_id'
  has_many :favorited, class_name: "Favorite", foreign_key: 'favorited_id'
  
  validates_presence_of :email
  
  # require .edu email
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+edu\z/, message: "must end with .edu"
  
  # Photo uploader dependencies
  mount_uploader :photo, PhotoUploader
  crop_uploaded :photo
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  scope :inactive, ->  { where(status_code: 0)}
  scope :active, ->  { where("status_code <> 0")}
  
  # Only get users who have been favorited by the given user
  scope :friends_of, -> (user) {joins(:favorites).where("favoriter_id = ?", user.id)}
  
  scope :not_including, -> (user) {where("id <> ?",user.id)}
  
  # Meal plan code of 0 means that everyone is included.
  # Meal plan code of 1 or 2 must be matched exactly, or to anyone with 0.
  scope :meal_plan_code, ->(code) { where("meal_plan_code = 0 OR meal_plan_code = ? OR ? = 0", code,code) }
  scope :sellers, -> { where(status_code: 1)}
  scope :buyers, -> { where(status_code: 2)}
  
  scope :searching, -> { where(current_deal_id: nil) }
  
  USER_STATUSES = ["Not Seeking Deal",
                   "Selling",
                   "Buying"]
  
  MEAL_PLANS = ["Blocks and Dinex/Flex",
                "Dinex/Flex",
                "Blocks"]
  
  #### Location functionality
  HALF_CAMPUS = 0.005 # within half campus
  SAME_BUILDING = 0.001 # around the same building
  
  N_BOUND = 40.44455
  S_BOUND = 40.44015
  W_BOUND = -79.94755
  E_BOUND = -79.93691
  # north/south delta
  NS_DELTA = 0.001
  # east/west delta
  EW_DELTA = 0.002
  
  # Campus centers
  # CMU is assymetrical, so there is a different latitude center point for each area (east, west, center)
  C_CENTER_LONG = -79.943018
  C_CENTER = 40.442837
  C_W_CENTER = 40.442951
  C_E_CENTER = 40.442257
  
  def location_name
    if longitude and latitude
      direction = if latitude.between?(S_BOUND,N_BOUND) and longitude.between?(W_BOUND,E_BOUND)
        if longitude.between?(C_CENTER_LONG - EW_DELTA, C_CENTER_LONG + EW_DELTA)
          if latitude.between?(C_CENTER - NS_DELTA, C_CENTER + NS_DELTA)
            "Central"
          elsif latitude < C_CENTER
            "South"
          else
            "North"
          end
        elsif longitude < C_CENTER_LONG #west
          if latitude.between?(C_E_CENTER - NS_DELTA, C_E_CENTER + NS_DELTA)
            "West"
          elsif latitude < C_E_CENTER #south
            "Southwest"
          else #north
            "Northwest"
          end
        else # east
          if latitude.between?(C_W_CENTER - NS_DELTA, C_W_CENTER + NS_DELTA)
            "East"
          elsif latitude < C_W_CENTER #south
            "Southeast"
          else #north
            "Northeast"
          end
        end
      else
        "Off"
      end
      "#{direction} CMU Campus"
    else
      "No current location"
    end
  end
  ####
  
  #### Ratings functionality
  def ratings_as_buyer
    # Deals of status code = 1 are complete
    # Deals of status code = 2,3,4,5 are cancelled
    # Return the number of deals for each of these code, for sales and purchases
    @ratings_as_buyer ||= ratings_helper(self.purchases.where("seller_status_code <> 0").pluck(:seller_status_code))
  end
  
  def has_purchased
    ratings_as_buyer.values.reduce(:+) != 0
  end
  
  def ratings_as_seller
    @ratings_as_seller ||= ratings_helper(self.sales.where("buyer_status_code <> 0").pluck(:buyer_status_code))
  end
  
  def has_sold
    ratings_as_seller.values.reduce(:+) != 0
  end
  
  def ratings_helper(num_array)
    # for example: num_array = [1,1,3,2,4,1]
    ratings = {}
    for elem in 1..4
      ratings[elem.to_s] = 0
    end
    for elem in num_array
      ratings[elem.to_s] += 1 if (1..4).include?(elem.to_i)
    end
    ratings
  end
  ####
  
  #### Notifcation CSS and text
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
  ####
  
  def favoriter_ids
    # the stringified ids of the users that favorited this user
    self.favorited.pluck(:favoriter_id).map{|o|o.to_s}
  end
  
  def self.meal_plan_options
    MEAL_PLANS.each_with_index.map{|o,i| [o,i]}
  end
  
  def photo_url
    if photo.blank?
      "http://placehold.it/150x150"
    else
      photo.url(:thumb)
    end 
  end
  
  def small_photo_url
    if photo.blank?
      "http://placehold.it/100x100"
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
    "#{buying_or_selling} #{MEAL_PLANS[self.meal_plan_code.to_i]}"
  end
  
  # Real-time data
  after_save :relay_job
  before_update :match_user
  before_destroy :delete_favorites
  
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
  def delete_favorites
    favorites.destroy_all
    favorited.destroy_all
    current_deal.force_cancel if current_deal_id
  end
  
  def match_user
    if is_searching
      # Find a new matching user
      scope = User.searching.meal_plan_code(self.meal_plan_code).not_including(self).order(:search_start_time)
      scope = scope.friends_of(self) if self.friends_only?
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
    match_user = if is_buyer
      seller
    else
      buyer
    end
    match_user.save!
    UserMailer.match_email(match_user).deliver_later if match_user.notify_by_email
    DealRelayJob.perform_later(match_user)
  end
  
  def relay_job
    # Update the views.
    UserRelayJob.perform_later()
    DealRelayJob.perform_later(self)
    StatisticsRelayJob.perform_later()
  end
end
