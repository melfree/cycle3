class Favorite < ActiveRecord::Base
  #relationships
  #belongs_to :user

  belongs_to :favoriter, class_name: "User", foreign_key: "favoriter_id", dependent: :destroy
  belongs_to :favorited, class_name: "User", foreign_key: "favorited_id", dependent: :destroy
  
  validates_presence_of :favorited, :favoriter
  validates_uniqueness_of :favoriter_id, scope: [:favorited_id]
end
