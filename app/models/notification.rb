class Notification < ApplicationRecord
  after_create :create_push_notification
  enum status: { un_read: 0, read: 1 }
  enum alert: { enabled: 0, disabled: 1 }
  belongs_to :user, optional: true
  belongs_to :conversation, optional: true
  belongs_to :message, optional: true

  def create_push_notification
    require 'fcm'
    fcm_client = FCM.new(ENV['FIREBASE_SERVER_KEY'])
    options = { priority: 'high',
                notification: { body: self.body,
                                title: self.title,
                                user_id: self.user_id,
                }
    }
    if self.send_all == true && self.send_date == ""
      registration_ids=[]
        User.all.each do |user|
          registration_ids<< user.mobile_devices.pluck(:mobile_token) if present?
        end
        registration_ids.each do |registration_id|
          puts fcm_client.send(registration_id, options)
          puts "----------------------------------------------"
          puts "----------------------------------------------"
          puts "----------------------------------------------"
          puts "----------------------------------------------"
          puts "----------------------------------------------"
      end
      return
    end
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
