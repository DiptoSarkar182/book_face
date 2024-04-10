class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    "#{first_name} #{last_name}"
  end

  validates :first_name, :last_name, presence: true, length: { minimum: 3 }
  validate :birthday_must_be_at_least_one_year_in_the_past
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :liked_posts, through: :post_likes, source: :post
  has_many :friend_requests, dependent: :destroy
  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: 'sender_id'
  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id'
  has_many :friend_lists, dependent: :destroy
  has_many :friends, through: :friend_lists
  has_one_attached :profile_image

  before_destroy :purge_profile_image
  before_update :purge_profile_image, if: :profile_image_changed?

  private
  def birthday_must_be_at_least_one_year_in_the_past
    if birthday.present? && birthday >= 1.year.ago.to_date
      errors.add(:birthday, 'must be at least one year in the past')
    end
  end

  def purge_profile_image
    if Rails.env.production?
      public_id = "ruby_on_rails/book_face/#{profile_image.key}"
      Cloudinary::Api.delete_resources([public_id], type: :upload, resource_type: :image)
    end
  end

  def profile_image_changed?
    profile_image.attached? && profile_image.attachment.blob_id_changed?
  end
end
