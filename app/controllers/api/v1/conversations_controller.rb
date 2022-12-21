class Api::V1::ConversationsController < Api::V1::ApiController
  before_action :authorize_request

  def index

  end

  def create
    @conversation = Conversation.find_by(sender_id: @current_user.id, receiver_id: params[:receiver_id])
    if @conversation.present?
      render json: { message: "Conversation Exists", conversation: @conversation }, status: :ok
    else
      @conversation=  Conversation.create!(receiver_id: @current_user.id,
                                           sender_id: params[:receiver_id].to_i)
      @conversation = Conversation.create!(sender_id: @current_user.id,
                                           receiver_id: params[:receiver_id].to_i)
      render json: { message: "Conversation Created", conversation: @conversation }, status: :ok
    end
  end

  def create_support_conversation
    @conversation = Conversation.find_by(sender_id: @current_user.id, admin_user_id: params[:admin_user_id]).present?
    if @conversation.present?
      render json: { message: "Conversation Exists", conversation: @conversation }, status: :not_found

    else
      @conversation = Conversation.create!(sender_id: @current_user.id,
                                           admin_user_id: params[:admin_user_id].to_i)
      render json: { message: "Conversation Created", conversation: @conversation }, status: :ok
    end
  end
end