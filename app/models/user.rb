class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  def full_name
    "#{first_name} #{last_name}"
  end


  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validate :birthday_must_be_at_least_one_year_in_the_past
  validates :bio, length: { maximum: 500 }
  validates :location, length: { maximum: 100 }
  validate :profile_image_size_under_limit

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  # has_many :friend_requests, dependent: :destroy
  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id', dependent: :destroy
  has_many :friend_lists, dependent: :destroy
  has_many :friends, through: :friend_lists
  has_one_attached :profile_image

  before_destroy :purge_profile_image
  before_update :purge_profile_image, if: :profile_image_changed?
  before_destroy :destroy_friend_lists

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.provider = auth.provider
      if auth.provider == 'google_oauth2'
        full_name = auth.info.name.split
        user.first_name = full_name[0]
        user.last_name = full_name[1..-1].join(' ')
      end
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      if user.new_record?
        user.save!
        UserMailer.with(user: user).welcome_email.deliver_later
      end
    end
  end

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

  def destroy_friend_lists
    FriendList.where(friend: self).destroy_all
  end
  def profile_image_size_under_limit
    if profile_image.attached? && profile_image.blob.byte_size > 5.megabytes
      profile_image.purge
      errors.add(:profile_image, 'is too large (max is 5MB)')
    end
  end
end
