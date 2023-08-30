class SendJudgeCoinWorker
  include Sidekiq::Worker
  # @queue= :deleting_queue
  def perform(*args ,id)
    banner = TournamentBanner.find_by(id: id)
    if banner.present? && banner.tournament_users.present?
      banner.tournament_users.each do |tournament_user|
        coins = tournament_user.user.coins
        coins += tournament_user.total_judged_coins
        tournament_user.user.update(coins: coins)
        UserMailer.tournament_judged_coins(tournament_user.user, tournament_user.total_judged_coins).deliver_now
      end
    end
  end
end