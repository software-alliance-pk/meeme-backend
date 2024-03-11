json.notifications_count @notifications.count
json.notifications @notifications.each do |notification|
  json.title notification[0] 
  json.data do
    notification[1].each do |notif|
      sender = User.find_by(id: notif.sender_id)
      json.id notif.id
      json.title notif.title
      json.user_id notif.user_id
      json.sender_id notif.sender_id
      json.send_all notif.send_all
      json.follow_request_id notif.follow_request_id
      json.body notif.body
      json.status notif.status
      json.alert notif.alert
      json.created_at notif.created_at
      json.updated_at notif.updated_at
      json.notification_type notif.notification_type
      json.sender_name notif.sender_name
      json.sender_image sender&.profile_image&.attached? ? sender.profile_image.blob.url : ''
    end
  end
end
