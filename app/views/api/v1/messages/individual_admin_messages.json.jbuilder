json.messages_count @messages.count
json.messages @messages.each do|message|
  json.id message.id
  json.body message.body
  json.subject message.subject.split("_").join(" ")
  json.message_ticket message.message_ticket
  json.conversation_id message.conversation_id
  json.sender_id message.sender_id
  json.sender_name message.sender.username
  json.admin_user_id message.admin_user.id
  json.admin_user_name message.admin_user.admin_user_name.present? ? message.admin_user.admin_user_name : ''
  json.created_at message.created_at
  json.message_image message.message_image.attached? ? message.message_image.blob.url : ''
  json.sender_image message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : ''
  json.status message.conversation.status
end