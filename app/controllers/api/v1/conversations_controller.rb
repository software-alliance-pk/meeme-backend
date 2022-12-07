class Api::V1::ConversationsController < Api::V1::ApiController
  before_action :authorize_request

  def index

  end

  def create
    @conversation = Conversation.find_by(sender_id: @current_user.id, receiver_id: params[:receiver_id]).present?
    if @conversation.present?
      render json: { message: "Conversation Exists", conversation: @conversation }, status: :not_found

    else
      @conversation = Conversation.create!(sender_id: @current_user.id,
                                           receiver_id: params[:receiver_id].to_i)
    end
  end
end