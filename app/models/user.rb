class User < ActiveRecord::Base
  validates_presence_of :email
  
  mount_uploader :photo, PhotoUploader
  crop_uploaded :photo
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :messages
  has_many :comments
  
  scope :buyers, -> { where(status: "buyer")}
  scope :sellers, -> { where(status: "seller")}
  
  def photo_url
    if photo.blank?
      "http://placehold.it/150x150"
    else
      photo.url(:thumb)
    end 
  end
  
  def is_seller
    self.status.to_i == 1
  end
  
  def is_buyer
    [2,3,4].include?(self.status.to_i)
  end
  
  def status_name
    STATUSES[self.status.to_i]
  end
  STATUSES = ["Not Available",
              "Selling",
              "Buying - Any",
              "Buying - Blocks Only",
              "Buying - Dinex/Flex Only"]
  def location_name
    LOCATIONS[self.location.to_i]
  end
  LOCATIONS = ["Upper CUC",
               "Lower CUC",
               "Entropy",
               "Wean Hall"]
  
  # Real-time data
  after_commit :relay_job
    
  private
  def relay_job
    HomeRelayJob.perform_later(self)
  end
end