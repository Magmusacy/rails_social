require 'digest/md5'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :invitations
  # Shows this user's pending invitations (send by others)
  has_many :pending_invitations, -> { where(confirmed: false) }, class_name: "Invitation", foreign_key: "friend_id"

  def friends
    user_friends = Invitation.where(user_id: self.id).where(confirmed: true).pluck(:friend_id)
    user_friend_of = Invitation.where(friend_id: self.id).where(confirmed: true).pluck(:user_id)
    User.where(id: [user_friends + user_friend_of])
  end

  def suggested_friends
    User.where.not(id: friends).where.not(id: id)
  end
  
  def profile_photo
    email_address = email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    "https://www.gravatar.com/avatar/#{hash}" 
  end
end
