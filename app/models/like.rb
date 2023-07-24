class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  validates :user_id, uniqueness: { scope: :likeable_id, message: ->(obj, data) { "You can like each #{obj.likeable_type} once" }  }

  def self.find_like(likeable, user)
    likeable.likes.find_by(user_id: user.id)
  end

  def self.like_exists?(likeable, user)
    self.find_like(likeable, user) != nil
  end
end
