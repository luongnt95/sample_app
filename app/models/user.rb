class User < ActiveRecord::Base
	attr_accessor :auth_token

	has_many :microposts, dependent: :destroy

	# dependent: :destroy callback just applies for Model#destroy not Model#delete
	# Can't destroy a self join table record eg: User.first.destroy will raise error
	has_many :following_relationships, dependent: :destroy
	has_many :following, through: :following_relationships, source: :followed
	has_many :inverse_of_following_relationships, class_name: "FollowingRelationship", foreign_key: :followed_id, dependent: :destroy
	has_many :followers, through: :inverse_of_following_relationships, source: :user

	before_save :downcase_email

	validates :name, presence: true, length: {maximum: 50, minimum: 2}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
	validates :password, presence: true, length: {minimum: 6}, allow_nil: true

	has_secure_password

	# Authentication
	def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember_auth_digest
		self.auth_token = User.new_token
		update_attribute :auth_digest, User.digest(auth_token)
	end

	def forget_auth_digest
		update_attribute :auth_digest, nil
	end

  def cookie_authenticate attribute, token  
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Microposts
  def find_recent_microposts
  	microposts.order_by_created_at_in_desc
  end

  # Following
  def following? other_user
  	following.include? other_user
  end

  # def follow followed_id
  # 	following_relationships.create followed_id: followed_id
  # end

  # def unfollow followed_id
  #   # delete may be faster than destroy because it doesn't affected by any callbacks !!?
  #   if relationship = following_relationships.find_by(followed_id: followed_id)
  # 		relationship.delete
  # 	end
  # end

  def find_relationship followed_id
  	following_relationships.find_by followed_id: followed_id 
  end

  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).delete
  end

  # News feed
  def feed
    # With complex sql it's much faster to use raw sql to optimize performance
    # following_ids = FollowingRelationship.where(user_id: id).pluck(:followed_id)
    following_ids = "SELECT followed_id FROM following_relationships WHERE user_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id).order_by_created_at_in_desc
  end

	private
		def downcase_email
			self.email = email.downcase
		end
end
