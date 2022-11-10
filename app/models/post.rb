class Post < ApplicationRecord
  scope :by_recently_created, -> (limit) { order(created_at: :desc).limit(limit) }

  validates :description, presence:true

  belongs_to :user
  has_one_attached :post_image ,dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes,dependent: :destroy
  belongs_to :tournament_banner,optional: true
end
