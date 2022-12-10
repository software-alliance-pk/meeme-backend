class MessageBroadCastJob < ApplicationJob
  queue_as :default

  def perform(message)
    if message.receiver_id.present?
      payload = {
        id: message.id,
        body: message.body,
        conversation_id: message.conversation_id,
        sender_id: message.sender_id,
        sender_name: message.sender.username,
        receiver_id: message.conversation.receiver.id.present? ? message.conversation.receiver.id : '',
        receiver_name: message.conversation.receiver.username,
        created_at: message.created_at,
        message_image: message.message_image.attached? ? message.message_image.blob.url : '',
        sender_image: message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : '',
        receiver_image: message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : ''
      }
      puts payload
      ActionCable.server.broadcast(build_conversation_id(message.conversation_id), payload)
    else
      payload = {
        id: message.id,
        body: message.body,
        subject: message.subject,
        conversation_id: message.conversation_id,
        admin_user_id: message.admin_user_id.present? ? message.admin_user_id : '',
        admin_user_name: message.admin_user.admin_user_name.present? ? message.admin_user.admin_user_name : '',
        admin_user_email: message.admin_user.email.present? ? message.admin_user.email : '',
        sender_id: message.sender_id,
        sender_name: message.sender.username,
        created_at: message.created_at,
        message_image: message.message_image.attached? ? message.message_image.blob.url : '',
        sender_image: message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : '',
      }
      puts payload
      ActionCable.server.broadcast(build_conversation_id(message.conversation_id), payload)
    end
  end

  def build_conversation_id(id)
    "conversation_#{id}"
  end
end