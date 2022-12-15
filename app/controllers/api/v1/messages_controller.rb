class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authorize_request

  def index
    @messages = []
    @chats = Conversation.where.not(receiver_id: nil).where("? IN (receiver_id)", @current_user.id).order("updated_at DESC")
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
    @messages = []
    @support_chats = Conversation.where(admin_user_id: 1, sender_id: @current_user.id).reverse
    # @support_chats = Message.where(admin_user_id: 1, sender_id: @current_user.id).reverse
    @support_chats.each do |chat|
      @messages << chat.messages.last if chat.messages.last.present?
    end
    if @messages.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end

  end

  def individual_messages
    @messages = (((Message.where(sender_id: @current_user.id, receiver_id: params[:receiver_id]))+(Message.where(receiver_id: @current_user.id, sender_id: params[:receiver_id]))).sort_by &:created_at).reverse
    if @messages.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end
  end

  def individual_admin_messages
    # @messages = ((Message.where(sender_id: @current_user.id, admin_user_id: params[:admin_user_id],message_ticket: params[:message_ticket]) + Message.where(sender_id: params[:admin_user_id], admin_user_id: @current_user.id,message_ticket: params[:message_ticket])).sort_by &:created_at).reverse
    @messages = ((Message.where(sender_id: @current_user.id, admin_user_id: params[:admin_user_id], message_ticket: params[:message_ticket])).sort_by &:created_at).reverse
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
    @conversation = Conversation.find_by(id: params[:conversation_id])
    # @secondary_conversation = Conversation.find_by(sender_id: params[:receiver_id], receiver_id: @current_user.id )
    if @conversation.present?
      # @secondary_message = @secondary_conversation.messages.new(secondary_message_params)
      # @secondary_message.save
      @message = @conversation.messages.new(message_params)
      @message.save
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  def support_ticket
    @conversation = Conversation.create!(sender_id: @current_user.id, admin_user_id: params[:admin_user_id])
    @secondary_conversation = Conversation.create!(receiver_id: @current_user.id, admin_user_id: params[:admin_user_id])
    if @conversation.present?
      @secondary_message = @secondary_conversation.messages.new(secondary_message_params)
      @secondary_message.save
      @message = @conversation.messages.new(message_params)
      @message.save
      @message.update(message_ticket: SecureRandom.hex(5))
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  def support_chat
    @conversation = Conversation.find_by(id: params[:conversation_id])
    # @conversation = Conversation.find_by(sender_id: @current_user.id, admin_user_id: params[:admin_user_id])
    if @conversation.present?
      subject = @conversation.messages.first.slice(:subject, :message_ticket).values
      @message = @conversation.messages.new(message_params)
      @message.save
      @message.update(subject: subject[0], message_ticket: subject[1])
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  private

  def message_params
    params.permit(:body, :receiver_id, :message_image, :admin_user_id, :subject, :message_ticket).merge(sender_id: @current_user.id, user_id: @current_user.id)
  end

  def secondary_message_params
    params.permit(:body, :message_image, :admin_user_id, :subject, :message_ticket).merge(receiver_id: @current_user.id, user_id: params[:receiver_id], sender_id: params[:receiver_id])
  end

  def admin_secondary_params
    params.permit(:body, :message_image, :subject, :message_ticket).merge(receiver_id: @current_user.id, user_id: params[:receiver_id], admin_user_id: params[:admin_user_id])
  end

end
