json.message do
  json.id @message.id
  json.subject @message.subject
  json.body @message.body
  json.message_ticket @message.message_ticket
  json.conversation_id @message.conversation_id
  json.admin_user_id @message.admin_user.id
  json.admin_user_name @message.admin_user.admin_user_name.present? ? @message.admin_user.admin_user_name : ''
  json.admin_user_email @message.admin_user.email
  json.sender_id @message.sender_id
  json.sender_name @message.sender.username
  json.created_at @message.created_at
  json.message_ticket @message.message_ticket
  json.message_image @message.message_image.attached? ? @message.message_image.blob.url : ''
  json.sender_image @message.sender.profile_image.attached? ? @message.sender.profile_image.blob.url : ''
end