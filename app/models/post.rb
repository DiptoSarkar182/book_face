class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :post_image

  before_destroy :purge_post_image

  private

  def purge_post_image
    if Rails.env.production?
      public_id = "ruby_on_rails/book_face/#{post_image.key}"
      Cloudinary::Api.delete_resources([public_id], type: :upload, resource_type: :image)
    end
  end
end
