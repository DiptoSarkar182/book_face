class Post < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, length: { maximum: 500 }
  validates :user, presence: true
  validate :post_image_size_under_limit
  validate :post_image_must_be_image

  has_many :comments, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :likers, through: :post_likes, source: :user
  has_one_attached :post_image

  before_destroy :purge_post_image
  before_update :purge_post_image, if: :post_image_changed?

  private
  def purge_post_image
    if Rails.env.production?
      public_id = "ruby_on_rails/book_face/#{post_image.key}"
      Cloudinary::Api.delete_resources([public_id], type: :upload, resource_type: :image)
    end
  end

  def post_image_changed?
    post_image.attached? && post_image.attachment.blob_id_changed?
  end

  def post_image_size_under_limit
    if post_image.attached? && post_image.blob.byte_size > 5.megabytes
      post_image.purge
      errors.add(:post_image, 'is too large (max is 5MB)')
    end
  end

  def post_image_must_be_image
    if post_image.attached? && !post_image.content_type.start_with?('image/')
      post_image.purge
      errors.add(:post_image, 'must be an image file')
    end
  end

end
