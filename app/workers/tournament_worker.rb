class TournamentWorker
  include Sidekiq::Worker
  # @queue= :deleting_queue
  def perform(*args)
    if TournamentBanner.first.present?
      TournamentBanner.first.tournament_users.each do |tournament_user|
        coins = tournament_user.user.coins
        coins += tournament_user.total_judged_coins
        tournament_user.user.update(coins: coins)
        UserMailer.tournament_judged_coins(tournament_user.user, tournament_user.total_judged_coins).deliver_now
      end
      # TournamentBanner.first.destroy
      puts "Banner Deleted"
    end
  end
end