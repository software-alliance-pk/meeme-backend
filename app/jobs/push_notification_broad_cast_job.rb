class PushNotificationBroadCastJob < ApplicationJob
    # queue_as :default
    # 
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
    def perform(body, title, date)
        # require 'fcm'
        # fcm_client = FCM.new(ENV['FIREBASE_SERVER_KEY'])
        # options = { priority: 'high',
        #             notification: { body: body,
        #                             title: title,
        #             }
        # }
        registration_ids=[]
        # User.all.each do |user|
        #   registration_ids << user.mobile_devices.pluck(:mobile_token) if present?
        # end
        # registration_ids.each do |registration_id|
        #   puts fcm_client.send(registration_id, options)
        #   puts "----------------------------------------------"
        #   puts "----------------------------------------------"
        #   puts "----------------------------------------------"
        #   puts "----------------------------------------------"
        #   puts "----------------------------------------------"
        # end
        # 
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
          puts("----------------------token: #{token}----------------")

          # FCM HTTP v1 Endpoint
          uri = URI.parse("https://fcm.googleapis.com/v1/projects/memee-app-368013/messages:send")
    
          # Notification payload
          options = {
            message: {
              topic: "all_users",
              notification: { body: self.body, title: self.title },
              data: {},   
            }
          }
          send_fcm_notification(uri, options, token)
          

          
    end
end