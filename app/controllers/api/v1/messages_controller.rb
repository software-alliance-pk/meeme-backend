class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authorize_request

  def index
    @messages=Message.where(sender_id: @current_user.id).group_by(&:receiver_id)
    @messages=Hash[@messages.to_a.reverse]
    if @messages.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end

  end

  def individual_messages
    @messages = Message.where(sender_id: @current_user.id, receiver_id: params[:receiver_id]).recently_created
    if @messages.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end

  end

  def create
    @conversation = Conversation.find_by(sender_id: @current_user.id, receiver_id: params[:receiver_id])
    if @conversation.present?
      @message = @conversation.messages.new(body: params[:body],
                                            sender_id: @current_user.id,
                                            user_id: @current_user.id,
                                            receiver_id: params[:receiver_id],
                                            message_image: params[:message_image])
      @message.save
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  def support
    @conversation = Conversation.find_by(sender_id: @current_user.id, receiver_id: params[:receiver_id])
    if @conversation.present?
      @message = @conversation.messages.new(body: params[:body],
                                            sender_id: @current_user.id,
                                            user_id: @current_user.id,
                                            receiver_id: params[:receiver_id],
                                            message_image: params[:message_image])
      @message.save
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

end