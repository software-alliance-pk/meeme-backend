class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation"
    # if params[:conversation_id].present?
    # else
    #   puts "conversation id is missing."
    # end
  end

  def unsubscribed
    stop_all_streams
  end
end
