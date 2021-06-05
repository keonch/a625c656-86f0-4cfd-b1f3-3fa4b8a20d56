class Like < ApplicationRecord
    validates_uniqueness_of :user_id, scope: :dog_id

    belongs_to :dog,
        class_name: :Dog,
        foreign_key: :dog_id

    belongs_to :user,
        class_name: :User,
        foreign_key: :user_id
end
