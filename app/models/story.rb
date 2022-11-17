class Story <ApplicationRecord
  scope :recently_created, -> { order(created_at: :desc) }
  has_one_attached :story_image,dependent: :destroy
  belongs_to :user
  has_many :likes,dependent: :destroy
  has_many :comments,dependent: :destroy

end