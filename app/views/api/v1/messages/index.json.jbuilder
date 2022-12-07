json.messages_count @messages.count
json.messages @messages.each_with_index do|index,message|
  json.id @messages[index].first.id
    json.body @messages[index].first.body
    json.conversation_id @messages[index].first.conversation_id
    json.sender_id @messages[index].first.sender_id
    json.sender_name @messages[index].first.sender.username
    json.receiver_id @messages[index].first.receiver.id
    json.receiver_name @messages[index].first.receiver.username
    json.created_at @messages[index].first.created_at
    json.message_image @messages[index].first.message_image.attached? ? @messages[index].first.message_image.blob.url : ''
    json.sender_image @messages[index].first.sender.profile_image.attached? ? @messages[index].sender.profile_image.blob.url : ''
    json.receiver_image @messages[index].first.receiver.profile_image.attached? ? @messages[index].first.reciever.profile_image.blob.url : ''
end