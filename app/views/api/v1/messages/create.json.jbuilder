json.message do
  json.id @message.id
  json.body @message.body
  json.conversation_id @message.conversation_id
  json.sender_id @message.sender_id
  json.sender_name @message.sender.username
  json.sender_active_status @message.sender.status
  json.receiver_id @message.conversation.receiver.id
  json.receiver_name @message.conversation.receiver.username
  json.receiver_active_status @message.conversation.receiver.status
  json.created_at @message.created_at
  json.message_images_count @message.message_images.count
  json.message_images @message.message_images.each do |message_image|
    json.message_image message_image.present? ? CloudfrontUrlService.new(message_image).cloudfront_url : ''
  end
  json.sender_image @message.sender.profile_image.attached? ? CloudfrontUrlService.new(@message.sender.profile_image).cloudfront_url : ''
  json.receiver_image @message.receiver.profile_image.attached? ? CloudfrontUrlService.new(@message.receiver.profile_image).cloudfront_url : ''
  end