class PushNotificationBroadCastJob < ApplicationJob
    # queue_as :default
    def perform(body, title, date)
        require 'fcm'
        fcm_client = FCM.new(ENV['FIREBASE_SERVER_KEY'])
        options = { priority: 'high',
                    notification: { body: body,
                                    title: title,
                    }
        }
        registration_ids=[]
        User.all.each do |user|
          registration_ids << user.mobile_devices.pluck(:mobile_token) if present?
        end
        registration_ids.each do |registration_id|
          puts fcm_client.send(registration_id, options)
          puts "----------------------------------------------"
          puts "----------------------------------------------"
          puts "----------------------------------------------"
          puts "----------------------------------------------"
          puts "----------------------------------------------"
        end
    end
end