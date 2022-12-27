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
                data: { notification: self, user_id: self.user_id,
                notification: { body: self.body,
                                title: 'MEMEE App Notification',
                                user_id: self.user_id,
                } }
    }
    registration_ids = user.mobile_devices.pluck(:mobile_token)
    unless user.notifications.first&.disabled?
      registration_ids.each do |registration_id|
        puts fcm_client.send(registration_id, options)
        puts "------------------------------------------"
        puts "------------------------------------------"
        puts "------------------------------------------"
        puts "------------------------------------------"
        puts "------------------------------------------"
        puts "------------------------------------------"
  



      end
    end
  end

end
