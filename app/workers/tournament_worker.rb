class TournamentWorker
  include Sidekiq::Worker
  # @queue= :deleting_queue
  def perform(*args, banner_id)
    TournamentBanner.find(banner_id).update(enable: false)
    puts "Status Updated"
  end
end