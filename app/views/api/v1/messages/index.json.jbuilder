json.messages_count @chats.count
json.messages @chats.each do |record|
    json.id record.messages&.last&.id
    json.body record.messages&.last&.body
    json.conversation_id record.id
    json.sender_id record&.sender_id
    json.sender_name record&.sender&.username
    json.receiver_id record&.receiver&.id
    json.receiver_name record&.receiver&.username
    json.created_at record.created_at
    json.message_image record&.messages.last&.message_image&.attached? ? record&.messages.last&.message_image.blob.url : ''
    json.sender_image record&.sender&.profile_image&.attached? ? record.sender.profile_image.blob.url : ''
    json.receiver_image record&.receiver&.profile_image&.attached? ? record.receiver.profile_image.blob.url : ''
end
