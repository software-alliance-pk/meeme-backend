json.messages_count @messages.count
json.messages @messages.each do |message|
  post = Post.find_by(id: message.post_id)
  json.id message.id
  json.body message.body
  json.subject message.subject
  json.message_ticket message.message_ticket
  json.conversation_id message.conversation_id
  json.admin_user_id message.admin_user_id
  json.admin_user_name 1
  json.created_at message.created_at
  json.message_images_count message.message_images.count
  json.message_images message.message_images.each do |message_image|
  if message_image.present?
    json.message_image message_image.blob.url
    json.content_type message_image.blob.content_type
    json.thumbnail post&.video_thumbnail&.attached? ? post&.video_thumbnail&.blob&.url : ''
  else
    json.message_image ''
    json.content_type ''
  end

  end
  json.sender_id message.sender_id
  json.sender_name message.sender.present? ? message.sender.username : ''
  json.sender_active_status message.sender.present? ? message.sender.status : ''

  if message.sender.present?
    json.sender_image message.sender.profile_image.attached? ? message.sender.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
  else
    json.sender_image message.admin_user.admin_profile_image.attached? ? message.admin_user.admin_profile_image.blob.url : ''
  end

  # if message.admin_user.present?
  #   json.sender_image message.admin_user.admin_profile_image.attached? ? message.admin_user.admin_profile_image.blob.url : ''
  # else
  #   json.sender_image ''
  # end

  json.receiver_id message.receiver_id
  json.receiver_name message.receiver.present? ? message.receiver.username : ''

  if message.admin_user.present?
    json.receiver_image message.admin_user.admin_profile_image.attached? ? message.admin_user.admin_profile_image.blob.url : ''
  else
    json.receiver_image ''
  end
  json.status message.conversation.status
end