class TournamentRulesController < ApplicationController
  def create
    return unless params[:tournament_banner_id].present?

    @rules = TournamentBannerRule.first
    @rules_array = []
    @rules_array << params[:rules]
    if @rules.present?
      @rules.update(tournament_banner_id: params[:tournament_banner_id], rules: @rules_array)
    else
      TournamentBannerRule.create!(tournament_banner_id: params[:tournament_banner_id], rules: @rules_array)
    end
  end

  private

  def rules_params
    params.permit(:rules, :tournament_banner_id)
  end
end