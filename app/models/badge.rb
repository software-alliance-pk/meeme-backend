class Badge < ApplicationRecord
  has_many :user_badges
  has_many :users, through: :user_badges
  has_one_attached :badge_image
  enum rarity:[:Rarity1,:Rarity2,:Rarity3]
end
