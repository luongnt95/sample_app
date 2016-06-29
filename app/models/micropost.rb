class Micropost < ActiveRecord::Base
  belongs_to :user, counter_cache: :microposts_count
  
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  scope :order_by_created_at_in_desc, -> {order(created_at: :desc)}
end