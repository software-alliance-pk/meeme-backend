class TournamentBanner < ApplicationRecord
  has_many :tournament_users
  has_many :users, through: :tournament_users
  has_many :posts
  has_many :likes
  has_one_attached :tournament_banner_photo ,dependent: :destroy
  has_one :ranking_price,dependent: :destroy
  has_one :tournament_banner_rule,dependent: :destroy
end