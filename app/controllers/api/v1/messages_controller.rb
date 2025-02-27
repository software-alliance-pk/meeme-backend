require 'tempfile'
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

  def change_status_to_read
    @conversation = Conversation.find_by(id: params[:conversation_id])
    if @conversation.present?
        # Setting unread_id to 0 means Both Sender and Reciever read the chat and No Unread message for both.
      @conversation.update(unread_id: 0)
      render json: { message: "Conversation status updated successfully" }, status: :ok
    else
      render json: { message: "No converation present" }, status: :not_found
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
    @messages =   Message.where(sender_id: @current_user.id,message_ticket: params[:message_ticket]).first.conversation_id
    @messages= Conversation.find_by(id: @messages).messages.reverse
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
      message_images = params.delete(:message_images)
      @message = @conversation.messages.new(message_params)
      if message_images.present?
        message_images.each do |image|
          if image.content_type == "image/heic"
            message_blob = convert_heic_to_jpeg(image) # Use the correct method for conversion
            if message_blob.present? # Check if conversion was successful
              @message.message_images.attach(message_blob) # Directly attach the converted blob
            end
          elsif  image.content_type != "image/heic"
            @message.message_images.attach(image) # Attach other image formats directly
          end
        end
      end
      if @message.save
        @conversation.update(unread_id: @message.receiver_id)
        ActionCable.server.broadcast("conversation_#{params[:conversation_id]}", { title: "message created", body: render_message(@message) })
        Notification.create(title:"New Message from #{@message.sender.username}",
                            body: @message.body,
                            conversation_id: @conversation.id,
                            user_id: @message.receiver_id,
                            message_id: @message.id,
                            notification_type: 'message',
                            sender_id: @current_user.id,
                            sender_name: @current_user.username)
      end
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  def support_ticket
    @conversation = Conversation.create!(sender_id: @current_user.id, admin_user_id: params[:admin_user_id], status: 'Ongoing', unread_id: params[:admin_user_id])
    if @conversation.present?
      message_images = params.delete(:message_images)
      @message = @conversation.messages.new(message_params)
      @message.message_ticket = SecureRandom.hex(5)
      if message_images.present?
        message_images.each do |image|
          if image.content_type == "image/heic" 
            message_blob = convert_heic_to_jpeg(image) # Use the correct method for conversion
            if message_blob.present? # Check if conversion was successful
              @message.message_images.attach(message_blob) # Directly attach the converted blob
            end
          elsif  image.content_type != "image/heic"
            @message.message_images.attach(image) # Attach other image formats directly
          end
        end
      end
      if @message.save
        # @message.update(message_ticket: SecureRandom.hex(5))
        ActionCable.server.broadcast("conversation_#{@conversation.id}", { title: "message created", body: render_message(@message) })
        Notification.create(title:"#{@message.sender.username} generated a support ticket",
                            body: @message.body,
                            conversation_id: @conversation.id,
                            user_id: @message.sender_id,
                            message_id: @message.id,
                            notification_type: 'admin_message',
                            sender_id: @current_user.id,
                            sender_name: @current_user.username,
                            redirection_type: 'support'
                            )
      end
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

 

  def convert_heic_to_jpeg(uploaded_file)
    begin
      # Create a temporary file for the HEIC input
      temp_heic = Tempfile.new(['image', '.heic'], binmode: true)
      temp_heic.write(uploaded_file.read)
      temp_heic.rewind

      # Create a temporary file for the converted JPEG output
      temp_jpg = Tempfile.new(['image', '.jpg'], binmode: true)
      temp_jpg.close # Close it to avoid conflicts with ImageMagick

      # Convert HEIC to JPEG using ImageMagick
      system("magick convert #{temp_heic.path} #{temp_jpg.path}")

      # Upload the converted file to ActiveStorage
      converted_blob = ActiveStorage::Blob.create_and_upload!(
        io: File.open(temp_jpg.path, 'rb'),
        filename: "#{SecureRandom.hex(10)}.jpg",
        content_type: "image/jpeg"
      )

      converted_blob
    rescue => e
      Rails.logger.error "Error while converting HEIC: #{e.message}"
      nil
    ensure
      # Cleanup temp files
      temp_heic.close! if temp_heic
      temp_jpg.close! if temp_jpg
    end
  end
  def support_chat
    @conversation = Conversation.find_by(id: params[:conversation_id])
    if @conversation.present?
      subject = @conversation.messages.first.slice(:subject, :message_ticket).values
      @message = @conversation.messages.new(message_params)
        @message.subject = subject[0]
        @message.message_ticket = subject[1]
        @conversation.update(unread_id: @conversation.admin_user_id)
      if @message.save
        # @message.update(subject: subject[0], message_ticket: subject[1])
        ActionCable.server.broadcast("conversation_#{params[:conversation_id]}", { title: "message created", body: render_message(@message) })
        Notification.create(title:"New Message from #{@message.sender.username}",
                            body: @message.body,
                            conversation_id: @conversation.id,
                            user_id: @message.sender_id,
                            message_id: @message.id,
                            notification_type: 'admin_message',
                            sender_id: @current_user.id,
                            sender_name: @current_user.username,
                            redirection_type: 'support'
                            )
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
        admin_user_name: 1,
        admin_user_email: '',
        sender_id: message.sender_id,
        sender_name: message.sender.username,
        created_at: message.created_at,
        message_ticket: message.message_ticket,
        message_images_count:  message.message_images.count,
        message_images: message.message_images.map{|message_image| message_image.present? ? message_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''} ,
        # message_image: message.message_image.attached? ? message.message_image.blob.url : '',
        sender_image: message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : '',
        ticket_status: message.conversation.status,
      }
    end
  end

end
