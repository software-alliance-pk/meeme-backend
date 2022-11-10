class TournamentBanner < ApplicationRecord
  has_many :tournament_users
  has_many :users, through: :tournament_users
end