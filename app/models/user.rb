require 'digest/md5'

class User < ApplicationRecord
  before_save :capitalize_name

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: %i[github google_oauth2]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :invitations, dependent: :destroy
  # Shows this user's pending invitations (sent by others)
  has_many :pending_invitations, -> { where(confirmed: false) }, class_name: "Invitation", foreign_key: "friend_id", dependent: :destroy
  has_many :liked_posts, -> { where(likeable_type: "Post") }, class_name: "Like", foreign_key: "user_id",  dependent: :destroy
  has_many :liked_comments, -> { where(likeable_type: "Comment") }, class_name: "Like", foreign_key: "user_id",  dependent: :destroy
  has_one_attached :avatar
  has_one_attached :background_photo

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      if auth.provider == "google_oauth2"
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
      else
        user.first_name = auth.info.name
        user.last_name = nil
      end

      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.image = auth.info.image 
    end
  end

  def friends
    user_friends = Invitation.where(user_id: self.id).where(confirmed: true).pluck(:friend_id)
    user_friend_of = Invitation.where(friend_id: self.id).where(confirmed: true).pluck(:user_id)
    User.where(id: [user_friends + user_friend_of])
  end

  def suggested_friends
    User.where.not(id: friends).where.not(id: id).where.not(id: pending_invitations.pluck(:user_id))
  end
  
  def profile_photo
    return image if image
    email_address = email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    "https://www.gravatar.com/avatar/#{hash}" 
  end

  private

  def capitalize_name
    first_name&.capitalize!
    last_name&.capitalize!
  end

  def email_required?
    provider.blank?
  end
end
