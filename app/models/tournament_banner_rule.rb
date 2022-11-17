class TournamentBannerRule <ApplicationRecord
  belongs_to :tournament_banner ,dependent: :destroy
end