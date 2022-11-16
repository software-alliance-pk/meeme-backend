class TournamentBanner < ApplicationRecord
  has_many :tournament_users
  has_many :users, through: :tournament_users
  has_many :posts
  has_one_attached :tournament_banner_photo ,dependent: :destroy
end