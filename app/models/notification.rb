class Notification < ApplicationRecord
  after_create :create_push_notification
  enum status: { un_read: 0, read: 1 }
  enum alert: { enabled: 0, disabled: 1 }
  enum notification_type: { no_type: 0, message: 1, request_send: 2, request_accepted: 3, coin_buy: 4,admin_message: 5, in_app_purchase: 6,sign_up: 7,comment: 8, push_notification: 9, tournament_winner: 10, tournament_judge: 11 }
  belongs_to :user, optional: true
  belongs_to :conversation, optional: true
  belongs_to :message, optional: true
  # belongs_to :comment, optional: true
  #comment added 

def create_push_notification
  require 'googleauth'
  require 'net/http'
  require 'uri'
  require 'json'

  puts "---------------------------------------------- "
  puts "----------------------------------------------"
  # OAuth2 Authentication
  scope = 'https://www.googleapis.com/auth/cloud-platform'
  authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
    json_key_io: File.open(Rails.root.join('config', 'memee-app-368013-firebase-adminsdk-oqrff-89e1fcba83.json')),
    scope: scope
  )
  token = authorizer.fetch_access_token!

  # FCM HTTP v1 Endpoint
  uri = URI.parse("https://fcm.googleapis.com/v1/projects/memee-app-368013/messages:send")
  reciever = User.find_by(id: user_id)
  sender = User.find_by(id: sender_id)
  # Notification payload
  options = {
    message: {
      token: "", # Token to be set below
      notification: { body: self.body, title: self.title },
      data: { notification_type: self.notification_type, conversation_id: self.conversation_id.to_s, sender_id: self.sender_id.to_s, sender_name: self.sender_name, reciever_id: self.user_id.to_s, reciever_name: reciever.username, sender_image: sender&.profile_image&.attached? ? sender.profile_image.blob.url : '', reciever_image: reciever.profile_image.attached? ? reciever.profile_image.blob.url : ''},   
    }
  }
  # send_fcm_notification(uri, options, token)

  if notification_type == 'comment'
    CommentNotificationWorker.perform_in(Time.now, self.body, self.title, notification_type, self.user_id, user.id, self.post_id)
  end

  if notification_type == 'tournament_winner' || notification_type == 'tournament_judge'
    TournamentNotificationWorker.perform_in(Time.now, self.body, self.title, notification_type, self.user_id)
  end

  if notification_type != 'admin_message' && notification_type != 'push_notification' && notification_type != 'comment' && notification_type != 'tournament_winner' && notification_type != 'tournament_judge'
    registration_ids = self.user.mobile_devices.pluck(:mobile_token) if self.user.present?
    puts "User: #{self.user.inspect}" 
    puts "Mobile Tokens: #{registration_ids.inspect}" 
    if user.notifications_enabled?
      registration_ids.each do |registration_id|
        options[:message][:token] = registration_id
        puts "----------------------------------------------"
        puts "------ Options ----------- #{options}"
        puts "----------------------------------------------"
       
        send_fcm_notification(uri, options, token)
      end
    end
  end
end

private

def send_fcm_notification(uri, options, token)
  headers = {
    'Content-Type': 'application/json',
    'Authorization': "Bearer #{token['access_token']}"
  }
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Post.new(uri.request_uri, headers)
  request.body = options.to_json
  response = http.request(request)
  puts "----------------------------------------------"
  puts "------ rrresponse  ----------- #{response.body}"
  puts "----------------------------------------------"
  puts response.body
end

end
