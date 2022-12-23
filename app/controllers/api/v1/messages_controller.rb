class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authorize_request

  def index
    @messages = []
    @chats = Conversation.where("receiver_id = (?) or sender_id = (?)", @current_user.id, @current_user.id).order("updated_at DESC")
    @chats = @chats.where(admin_user_id: nil)
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
    @support_chats.each do |chat|
      @messages << chat.messages.last if chat.messages.last.present?
    end
    if @messages.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end

  end

  def individual_messages
    @messages = (((Message.where(sender_id: @current_user.id, receiver_id: params[:receiver_id])) + (Message.where(receiver_id: @current_user.id, sender_id: params[:receiver_id]))).sort_by &:created_at).reverse
    if @messages.present?
    else
      render json: { message: "No message present" }, status: :not_found
    end
  end

  def individual_admin_messages
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
    if @conversation.present?
      @message = @conversation.messages.new(message_params)
      if @message.save
        ActionCable.server.broadcast("conversation_#{params[:conversation_id]}", { title: "message created", body: render_message(@message) })
        Notification.create(body: 'You have received a message',
                            conversation_id: @conversation.id,
                            user_id: @message.receiver_id )
      end
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  def support_ticket
    @conversation = Conversation.create!(sender_id: @current_user.id, admin_user_id: params[:admin_user_id], status: 'Pending')
    if @conversation.present?
      @message = @conversation.messages.new(message_params)
      if @message.save
        @message.update(message_ticket: SecureRandom.hex(5))
        ActionCable.server.broadcast("conversation_#{@conversation.id}", { title: "message created", body: render_message(@message) })
      end
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  def support_chat
    @conversation = Conversation.find_by(id: params[:conversation_id])
    if @conversation.present?
      subject = @conversation.messages.first.slice(:subject, :message_ticket).values
      @message = @conversation.messages.new(message_params)
      if @message.save
        @message.update(subject: subject[0], message_ticket: subject[1])
        ActionCable.server.broadcast("conversation_#{params[:conversation_id]}", { title: "message created", body: render_message(@message) })
      end
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  private

  def message_params
    params.permit(:body, :receiver_id, :admin_user_id, :subject, :message_ticket, message_images: []).merge(sender_id: @current_user.id, user_id: @current_user.id)
  end

  def secondary_message_params
    params.permit(:body, :message_image, :admin_user_id, :subject, :message_ticket).merge(receiver_id: @current_user.id, user_id: params[:receiver_id], sender_id: params[:receiver_id])
  end

  def admin_secondary_params
    params.permit(:body, :message_image, :subject, :message_ticket).merge(receiver_id: @current_user.id, user_id: params[:receiver_id], admin_user_id: params[:admin_user_id])
  end

  def render_message(message)
    if message.receiver_id.present?
      {
        id: message.id,
        body: message.body,
        conversation_id: message.conversation_id,
        sender_id: message.sender_id,
        sender_name: message.sender.username,
        receiver_id: message.conversation.receiver.id.present? ? message.conversation.receiver.id : '',
        receiver_name: message.conversation.receiver.username,
        created_at: message.created_at,
        message_images_count:  message.message_images.count,
        message_images: message.message_images.map{|message_image| message_image.present? ? message_image.blob.url : ''} ,
        # message_image: message.message_image.attached? ? message.message_image.blob.url : '',
        sender_image: message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : '',
        receiver_image: message.receiver.profile_image.attached? ? message.receiver.profile_image.blob.url : ''
      }
    else
      {
        id: message.id,
        body: message.body,
        subject: message.subject.split("_").join(" "),
        conversation_id: message.conversation_id,
        admin_user_id: message.admin_user_id.present? ? message.admin_user_id : '',
        admin_user_name: message.admin_user.admin_user_name.present? ? message.admin_user.admin_user_name : '',
        admin_user_email: message.admin_user.email.present? ? message.admin_user.email : '',
        sender_id: message.sender_id,
        sender_name: message.sender.username,
        created_at: message.created_at,
        message_ticket: message.message_ticket,
        message_images_count:  message.message_images.count,
        message_images: message.message_images.map{|message_image| message_image.present? ? message_image.blob.url : ''} ,
        # message_image: message.message_image.attached? ? message.message_image.blob.url : '',
        sender_image: message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : '',
        ticket_status: message.conversation.status,
      }
    end
  end

end
