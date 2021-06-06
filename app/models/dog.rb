class Dog < ApplicationRecord
  has_many_attached :images

  belongs_to :owner,
    required: false,
    class_name: :User,
    foreign_key: :owner_id

  has_many :likes,
    class_name: :Like,
    foreign_key: :dog_id
  
  scope :liked_an_hour_ago, -> { joins(:likes).where('likes.created_at > ?', 1.hour.ago).group('dogs.id') }
  scope :most_likes, -> { order('COUNT(likes.id) DESC') }
  scope :most_recent, -> { order(created_at: :desc) }
  
  scope :sorted, -> (sort_type) {
    case sort_type
      when "new"
        return most_recent
      when "rising"
        return liked_an_hour_ago.most_likes
      else
        return most_recent
      end
  }

  scope :paginated, -> (page: 1, n: 5) {
    limit(n).offset((page - 1) * n)
  }
end
