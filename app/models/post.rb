class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :post_image do |attachable|
    attachable.variant :thumb, resize_to_fill: [80, 80]
  end
  before_destroy :purge_post_image
  before_update :purge_post_image
  private
  def purge_post_image
    if Rails.env.production?
      public_id = "ruby_on_rails/book_face/#{post_image.key}"
      Cloudinary::Api.delete_resources([public_id], type: :upload, resource_type: :image)
    end
  end
end
