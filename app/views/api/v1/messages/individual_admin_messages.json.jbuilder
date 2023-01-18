json.messages_count @messages.count
json.messages @messages.each do |message|
  json.id message.id
  json.body message.body
  json.subject message.subject.split("_").join(" ")
  json.message_ticket message.message_ticket
  json.conversation_id message.conversation_id
  json.admin_user_id message.admin_user.id
  json.admin_user_name message.admin_user.admin_user_name.present? ? message.admin_user.admin_user_name : ''
  json.created_at message.created_at
  json.message_images_count message.message_images.count
  json.message_images message.message_images.each do |message_image|
    json.message_image message_image.present? ? message_image.blob.url : ''
  end
  json.sender_id message.sender_id
  json.sender_name message.sender.present? ? message.sender.username : ''
  json.sender_active_status message.sender.present? ? message.sender.status : ''

  if message.sender.present?
    json.sender_image message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : ''
  else
    json.sender_image ''
  end

  json.receiver_id message.receiver_id
  json.receiver_name message.receiver.present? ? message.receiver.username : ''

  if message.receiver.present?
    json.receiver_image message.receiver.profile_image.attached? ? message.receiver.profile_image.blob.url : ''
  else
    json.receiver_image ''
  end
  json.status message.conversation.status
end