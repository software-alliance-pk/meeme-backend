class ConversationChannel < ApplicationCable::Channel
  def subscribed
    if params[:conversation_id].present?
      stream_from("conversation_#{(params[:conversation_id])}")
    else
      puts "conversation id is missing."
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
