class PushNotificationWorker
  include Sidekiq::Worker
  def perform(*args, title, body, date)
    PushNotificationBroadCastJob.perform_now(title, body, date)
    puts "Hii"
  end
end