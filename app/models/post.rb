class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :post_image

  before_destroy :purge_post_image

  private

  def purge_post_image
    post_image.purge
  end
end
