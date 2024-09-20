json.notifications_count @notifications.count
json.notifications do
  @notifications.each do |date, notifications|
    json.child! do
      json.title date
      json.data do
        notifications.each do |notif|
          sender = User.find_by(id: notif.sender_id)
          json.child! do
            json.id notif.id
            json.body notif.body
            json.status notif.status
            json.alert notif.alert
            json.user_id notif.sender_id
            json.created_at notif.created_at
            json.updated_at notif.updated_at
            json.conversation_id notif.conversation_id
            json.message_id notif.message_id
            json.follow_request_id notif.follow_request_id
            json.title notif.title
            json.send_all notif.send_all
            json.send_date notif.send_date
            json.notification_type notif.notification_type
            json.sender_id notif.sender_id
            json.sender_name notif.sender_name
            json.sender_image sender&.profile_image&.attached? ? sender.profile_image.blob.url : ''
            if Follower.where(user_id: notif.sender_id, follower_user_id: @current_user.id, status: 'follower_added').present? && Follower.where(user_id: @current_user.id, follower_user_id: notif.sender_id, status: 'following_added').present?
              json.follow_each_other true
            elsif Follower.where(user_id: notif.sender_id, follower_user_id: @current_user.id, status: 'follower_added').present?
              json.follower_added true
            elsif Follower.where(user_id: notif.sender_id, follower_user_id: @current_user.id, status: 'pending').present?
              json.follow_request_send true
            end
          end
        end
      end
    end
  end
end