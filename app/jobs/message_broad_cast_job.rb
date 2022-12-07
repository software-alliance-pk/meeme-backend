class MessageBroadCastJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload = {
      id: message.id,
      body: message.body,
      conversation_id: message.conversation_id,
      sender_id: message.sender_id,
      sender_name: message.sender.username,
      receiver_id: message.conversation.receiver.id,
      receiver_name: message.conversation.receiver.username,
      created_at: message.created_at,
      message_image: message.message_image.attached? ? message.message_image.blob.url : '',
      sender_image: message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : '',
      receiver_image: message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : ''
    }
    puts payload
    ActionCable.server.broadcast(build_conversation_id(message.conversation_id), payload)
  end

  def build_conversation_id(id)
    "conversation_#{id}"
  end
end