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
  
  def photo_url
    if photo.blank?
      "http://placehold.it/150x150"
    else
      photo.url(:thumb)
    end 
  end
end
