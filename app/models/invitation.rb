class Invitation < ApplicationRecord
    belongs_to :user
    belongs_to :friend, class_name: "User", foreign_key: "friend_id" 

    validates :user_id, uniqueness: { scope: :friend_id } 

    scope :find_invitation, ->(user, friend) { (where(user_id: user).where(friend_id: friend)).or(where(user_id: friend).where(friend_id: user)) }
    scope :confirmed, -> { where(confirmed: true) }

    def contains?(user)
        user_id == user.id || friend_id == user.id 
    end
end
