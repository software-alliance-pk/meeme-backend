class Tutorial < ApplicationRecord
  validates :step, uniqueness: true
  has_many_attached :tutorial_images, dependent: :destroy
end
