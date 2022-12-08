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
    @messages = (Message.where(sender_id: @current_user.id, receiver_id: params[:receiver_id])+Message.where(sender_id: params[:receiver_id], receiver_id: @current_user.id))
    if @messages.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end
  end

  def fetch_all_users
    @users=User.where("LOWER(username) LIKE ?", "%#{params[:username].downcase}%").all
    if @users.present?
    else
      render json: { message: "No user present" }, status: :not_found
    end
  end

  def create
    @conversation = Conversation.find_by(sender_id: @current_user.id, receiver_id: params[:receiver_id])
    if @conversation.present?
      @message = @conversation.messages.new(message_params)
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
  private
  def message_params
    params.permit(:body,:receiver_id,:message_image).merge(sender_id: @current_user.id,user_id: @current_user.id)
  end

end
