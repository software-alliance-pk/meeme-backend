class CommentNotificationWorker
  include Sidekiq::Worker

  def perform(*args, body, title, type ,user_id, id)
    user = User.find_by(id: id)
    require 'fcm'
    fcm_client = FCM.new(ENV['FIREBASE_SERVER_KEY'])
    options = { priority: 'high',
                notification: { body: body,
                                title: title,
                                user_id: user_id,

                },
                data: {
                  notification_type: type
                }
    }

    registration_ids = user.mobile_devices.pluck(:mobile_token)
    if user.notifications_enabled?
      registration_ids.each do |registration_id|
        puts fcm_client.send(registration_id, options)
        puts "----------------------------------------------"
        puts "---------------------------------------------- "
        puts "----------------------------------------------"
        puts "----------------------------------------------"
        puts "----------------------------------------------"
      end
    end
  end
end