class Api::V1::ConversationsController < Api::V1::ApiController
  before_action :authorize_request

  def index

  end

  def create
    # Check if conversation exists with either user as sender or receiver
    @conversation = Conversation.find_by(
      "(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
      @current_user.id, params[:receiver_id],
      params[:receiver_id], @current_user.id
    )

    if @conversation.present?
      render json: { message: "Conversation Exists", conversation: @conversation }, status: :ok
    else
      @conversation = Conversation.create!(
        sender_id: @current_user.id,
        receiver_id: params[:receiver_id].to_i
      )
      # Notification.create(body: 'Conversation created successfully ',
      #                     conversation_id: @conversation.id,
      #                     user_id: @current_user.id )

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
      # Notification.create(body: 'Support Conversation created successfully ',
      #                     conversation_id: @conversation.id,
      #                     user_id: @current_user.id )
      render json: { message: "Conversation Created", conversation: @conversation }, status: :ok
    end
  end
end