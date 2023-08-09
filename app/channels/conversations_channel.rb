class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

    puts params
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

    if params[:conversation_id].present?
      puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      puts params[:conversation_id]
      puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      stream_from "conversation_#{params[:conversation_id]}"
    else
      puts "conversation id is missing."
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
