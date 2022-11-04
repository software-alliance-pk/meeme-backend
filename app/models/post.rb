class Post < ApplicationRecord
  validates :description, presence:true

  belongs_to :user
  has_one_attached :post_image ,dependent: :destroy
end
