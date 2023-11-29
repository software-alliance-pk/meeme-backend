class TournamentBannerController< ApplicationController
  def index
    @tournament_banner= TournamentBanner.all
  end
end