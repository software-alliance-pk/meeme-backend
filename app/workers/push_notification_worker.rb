class PushNotificationWorker
  include Sidekiq::Worker
  def perform(*args, title, body, date, notification_type)
    PushNotificationBroadCastJob.perform_now(title, body, date, notification_type)
    puts "Hii"
  end
end