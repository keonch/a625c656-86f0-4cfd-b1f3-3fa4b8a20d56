class Dog < ApplicationRecord
  has_many_attached :images

  belongs_to :owner,
    required: false,
    class_name: :User,
    foreign_key: :owner_id

  has_many :likes,
    class_name: :Like,
    foreign_key: :dog_id
  
  scope :recent_likes, -> { includes(:likes).where(likes: {created_at: Time.now-1.hour..Time.now}) }
end
