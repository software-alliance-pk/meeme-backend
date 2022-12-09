json.messages_count @chats.count
json.messages @chats.each do|chat|
    json.id chat.id
    json.body chat.body
    json.conversation_id chat&.conversation_id
    json.sender_id chat&.sender_id
    json.sender_name chat&.sender&.username
    json.receiver_id chat&.receiver&.id
    json.receiver_name chat&.receiver&.username
    json.created_at chat.created_at
    json.message_image chat&.message_image&.attached? ? chat.message_image.blob.url : ''
    json.sender_image chat&.sender&.profile_image&.attached? ? chat.sender.profile_image.blob.url : ''

    json.receiver_image chat&.receiver&.profile_image&.attached? ? chat.receiver.profile_image.blob.url : ''
end
