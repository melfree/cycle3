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
    if status and location
      "#{status_name} at #{location_name}"
    elsif status
      status_name
    else
      STATUSES[0]
    end
  end
  
  def status_name
    STATUSES[self.status.to_i]
  end
  STATUSES = ["I am not available",
              "I want to sell",
              "I want to buy anything",
              "I want to buy (blocks only)",
              "I want to buy (Dinex/Flex only)"]
  
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
  
  # Real-time data
  after_commit :relay_job
    
  private
  def relay_job
    UserRelayJob.perform_later(self)
  end
end