class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id" 
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_one_attached :image

  validate :must_contain_image_or_body
  validate :acceptable_image

  private

  def must_contain_image_or_body
    if image.attached? == false && body.nil?
      errors.add(:base, "Image or body must be present")
    end
  end

  def acceptable_image
    return unless image.attached?

    unless image.blob.byte_size <= 1.megabyte
      errors.add(:image, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG or PNG")
    end
  end
end
