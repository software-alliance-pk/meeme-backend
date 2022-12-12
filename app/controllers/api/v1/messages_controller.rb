class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authorize_request

  def index
    @messages = []
    # @messages = Message.where(sender_id: @current_user.id).group_by(&:receiver_id)
    # @messages = Message.where(receiver_id: @current_user.id) + Message.where(sender_id: @current_user.id)
    @chats = Conversation.where.not(receiver_id: nil).where("? IN (sender_id, receiver_id)", @current_user.id).order("updated_at DESC")
    @chats.each do |chat|
      @messages << chat.messages.last if chat.messages.last.present?
    end
    @messages = @messages.sort_by { |e| e[:created_at] }.reverse
    if @messages.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end
  end

  def all_support_chats
    # @support_chats=[]
    # @messages = Message.where(sender_id: @current_user.id).group_by(&:admin_user_id)
    # @messages.each_with_index do|key,value|
    #   @support_chats<< @messages.values[value].last
    # end
    # @support_chats=@support_chats.sort_by{|e| e[:created_at]}.reverse.select(&:admin_user_id)
    @support_chats = Message.where(admin_user_id: 1, sender_id: @current_user.id).reverse
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
    # @conversation = Conversation.find_by(sender_id: @current_user.id, admin_user_id: params[:admin_user_id])
    @conversation = Conversation.create!(sender_id: @current_user.id, admin_user_id: params[:admin_user_id])
    if @conversation.present?
      @message = @conversation.messages.new(message_params)
      @message.save
      @message.update(message_ticket: SecureRandom.hex(5))
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  private

  def message_params
    params.permit(:body, :receiver_id, :message_image, :admin_user_id, :subject, :message_ticket).merge(sender_id: @current_user.id, user_id: @current_user.id)
  end

end
