class TournamentNotificationWorker
  include Sidekiq::Worker

  def perform(*args, body, title, type ,user_id, sender_name, id)
    require 'googleauth'
    require 'net/http'
    require 'uri'
    require 'json'

    puts "------hello---------------------------------------- "
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
    
    # Notification payload
 
    user = User.find_by(id: user_id)
    # require 'fcm'
    # fcm_client = FCM.new(ENV['FIREBASE_SERVER_KEY'])
     options = {
    message: {
      token: "", # Token to be set below
      notification: { body: body, title: title },
      data: { notification_type: type, user_id: user_id.to_s, sender_name: sender_name, id: id.to_s}
    }
  }
  

    registration_ids = user.mobile_devices.pluck(:mobile_token)
    # if user.notifications_enabled?
      registration_ids.each do |registration_id|
        puts "User: #{user.inspect}" 
        puts "Mobile Tokens: #{registration_ids.inspect}" 
        options[:message][:token] = registration_id
        puts "----------------------------------------------"
        puts "------ Options ----------- #{options}"
        puts "----------------------------------------------"
       
        send_fcm_notification(uri, options, token)     
        puts "----------------------------------------------"
        puts "----------------------------------------------"
      end
    # end
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