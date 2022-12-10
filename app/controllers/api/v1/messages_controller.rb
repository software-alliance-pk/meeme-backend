class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authorize_request

  def index
    @chats=[]
    @messages = Message.where(sender_id: @current_user.id).group_by(&:receiver_id)
    @messages.each_with_index do|key,value|
      @chats<< @messages.values[value].last
    end
    @chats=@chats.sort_by{|e| e[:created_at]}.reverse.select(&:receiver_id)
    if @chats.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end
  end

  def all_support_chats
    @support_chats=[]
    @messages = Message.where(sender_id: @current_user.id).group_by(&:admin_user_id)
    @messages.each_with_index do|key,value|
      @support_chats<< @messages.values[value].last
    end
    @support_chats=@support_chats.sort_by{|e| e[:created_at]}.reverse.select(&:admin_user_id)
    if @support_chats.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end
  end

  def individual_messages
    @messages = ((Message.where(sender_id: @current_user.id, receiver_id: params[:receiver_id]) + Message.where(sender_id: params[:receiver_id], receiver_id: @current_user.id)).sort_by &:created_at).reverse
    if @messages.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end
  end
  def individual_admin_messages
    @messages = ((Message.where(sender_id: @current_user.id, admin_user_id: params[:admin_user_id]) + Message.where(sender_id: params[:admin_user_id], admin_user_id: @current_user.id)).sort_by &:created_at).reverse
    if @messages.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end
  end


  def fetch_all_users
    @users = User.where("LOWER(username) LIKE ?", "%#{params[:username].downcase}%").all
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

  def support_chat
    @conversation = Conversation.find_by(sender_id: @current_user.id, admin_user_id: params[:admin_user_id])
    if @conversation.present?
      @message = @conversation.messages.new(message_params)
      @message.save
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  private

  def message_params
    params.permit(:body, :receiver_id, :message_image,:admin_user_id).merge(sender_id: @current_user.id, user_id: @current_user.id)
  end

end
