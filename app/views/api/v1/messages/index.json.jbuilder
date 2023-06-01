json.messages_count @messages.count
json.messages @messages.each do |record|
    json.id record.id
    json.body record.body
    json.conversation_id record.conversation_id
    json.sender_id record&.sender_id
    json.sender_name record&.sender&.username
    json.sender_active_status record&.sender&.status
    json.receiver_id record&.receiver&.id
    json.receiver_name record&.receiver&.username
    json.receiver_active_status record&.receiver&.status
    json.created_at record.created_at
    json.message_images_count record.message_images.count
    json.message_images record.message_images.each do |message_image|
        json.message_image message_image.present? ? message_image.blob.url : ''
    end
    # json.message_image record.message_image&.attached? ? record&.message_image.blob.url : ''
    json.sender_image record&.sender&.profile_image&.attached? ? record.sender.profile_image.blob.url : ''
    json.receiver_image record&.receiver&.profile_image&.attached? ? record.receiver.profile_image.blob.url : ''
end
