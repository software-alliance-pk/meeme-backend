if params[:type] == 'block'
  json.blocked_user do
    json.id @block_user.id
    json.blocked_user_id @block_user.blocked_user_id
    json.block_by_id @block_user.user_id
  end
  json.success 'User Blocked Successfully'
else
  json.report_details do
    json.conversation do
      json.id @conversation.id
      json.sender_id @conversation.sender.id
      json.admin_user_id @conversation.admin_user_id
      json.status @conversation.status
    end

    json.message do
      json.id @message.id
      json.body @message.body
      json.conversation_id @message.conversation_id
      json.sender_id @message.sender_id
      json.sender_name @message.sender.username
      json.sender_active_status @message.sender.status
      json.created_at @message.created_at
      json.message_images_count @message.message_images.count
      json.message_images @message.message_images.each do |message_image|
        json.message_image message_image.present? ? message_image.blob.url : ''
      end
      json.sender_image @message.sender.profile_image.attached? ? @message.sender.profile_image.blob.url  : ''
    end
  end
end