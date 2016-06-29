class FollowingRelationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :followed, class_name: "User"
  # check if user really exists
  # what happens if a user has been deleted after was followed by others?
  validates :user_id, presence: true
  validates :followed_id, presence: true
end
