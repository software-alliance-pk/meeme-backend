class TournamentBannerRule <ApplicationRecord
  has_rich_text :body
  belongs_to :tournament_banner ,dependent: :destroy
end