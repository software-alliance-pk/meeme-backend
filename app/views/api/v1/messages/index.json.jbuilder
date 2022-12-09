json.messages_count @messages.count
json.messages @messages.each_with_index do|index,message|
    json.id @messages[index].last.id
    json.body @messages[index].last.body
    json.conversation_id @messages[index].last&.conversation_id
    json.sender_id @messages[index].last&.sender_id
    json.sender_name @messages[index].last&.sender&.username
    json.receiver_id @messages[index].last&.receiver&.id
    json.receiver_name @messages[index].last&.receiver&.username
    json.created_at @messages[index].last&.created_at
    json.message_image @messages[index].last&.message_image&.attached? ? @messages[index].last.message_image.blob.url : ''
    json.sender_image @messages[index].last&.sender&.profile_image&.attached? ? @messages[index].last.sender.profile_image.blob.url : ''
    json.receiver_image @messages[index].last&.receiver&.profile_image&.attached? ? @messages[index].last.receiver.profile_image.blob.url : ''
end
