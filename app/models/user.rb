class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    "#{first_name} #{last_name}"
  end
  validates :first_name, :last_name, presence: true, length: { minimum: 3 }
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :liked_posts, through: :post_likes, source: :post
end
