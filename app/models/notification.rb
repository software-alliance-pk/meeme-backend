class Notification < ApplicationRecord
  after_create :create_push_notification
  enum status: { un_read: 0, read: 1 }
  enum alert: { enabled: 0, disabled: 1 }
  enum notification_type: { no_type: 0, message: 1, request_send: 2, request_accepted: 3, coin_buy: 4,admin_message: 5, in_app_purchase: 6,sign_up: 7,comment: 8, push_notification: 9 }
  belongs_to :user, optional: true
  belongs_to :conversation, optional: true
  belongs_to :message, optional: true
  # belongs_to :comment, optional: true

  def create_push_notification
    require 'fcm'
    fcm_client = FCM.new(ENV['FIREBASE_SERVER_KEY'])
    options = { priority: 'high',
                notification: { body: self.body,
                                title: self.title,
                                user_id: self.user_id,

                },
                data: {
                  notification_type: self.notification_type
                }

    }
    
    if notification_type != 'admin_message' && notification_type != "push_notification"
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

end
