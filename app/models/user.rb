require 'digest/md5'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :invitations, dependent: :destroy
  # Shows this user's pending invitations (sent by others)
  has_many :pending_invitations, -> { where(confirmed: false) }, class_name: "Invitation", foreign_key: "friend_id", dependent: :destroy
  has_many :liked_posts, -> { where(likeable_type: "Post") }, class_name: "Like", foreign_key: "user_id",  dependent: :destroy
  has_many :liked_comments, -> { where(likeable_type: "Comment") }, class_name: "Like", foreign_key: "user_id",  dependent: :destroy

  def friends
    user_friends = Invitation.where(user_id: self.id).where(confirmed: true).pluck(:friend_id)
    user_friend_of = Invitation.where(friend_id: self.id).where(confirmed: true).pluck(:user_id)
    User.where(id: [user_friends + user_friend_of])
  end

  def suggested_friends
    User.where.not(id: friends).where.not(id: id).where.not(id: pending_invitations.pluck(:user_id))
  end
  
  def profile_photo
    email_address = email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    "https://www.gravatar.com/avatar/#{hash}" 
  end
end
