class Api::V1::BlockUsersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_user, only: [:create]
  before_action :find_blocked_user, only: [:create]

  def create
    if params[:type] == 'block'
      if @user.present?
        return render json: { message: 'User is already blocked' } if @blocked_user.present?

        @block_user = BlockUser.create(blocked_user_id: params[:user_id], user_id: @current_user.id)
        return render json: { errors: @block_user.errors.full_messages }, status: :bad_request unless @block_user.save
      else
        render json: { message: 'This user does not exist' }
      end
    elsif params[:type] == 'report'
      create_support_ticket
    elsif params[:type] == 'flag'
      @post = Post.find_by(id: params[:post_id])
      return render json: { message: 'Post already flagged' }, status: :bad_request if @post.flagged_by_user.include?(@current_user.id)
      @flagged = @post.flagged_by_user
      return render json: { message: 'Post not found' }, status: :not_found unless @post.present?

      @flagged << @current_user.id
      return render json: { error: @post.errors.full_messages }, status: :bad_request unless @post.update(flagged_by_user: @flagged)

      render json: { message: 'Post flagged successfully' }
    end
  end

  def create_support_ticket
    @conversation = Conversation.create!(sender_id: @current_user.id, admin_user_id: params[:admin_user_id], status: 'Ongoing')
    if @conversation.present?
      @message = @conversation.messages.new(message_params)
      @message.subject = 'Abuse'
      @message.message_ticket = SecureRandom.hex(5)
      @message.body = "#{@current_user.username} report #{@user.username} as doing abusive activity"
      if @message.save
        ActionCable.server.broadcast("conversation_#{@conversation.id}", { title: "message created", body: render_message(@message) })
        Notification.create(title:"#{@message.sender.username} generated a support ticket",
                            body: @message.body,
                            conversation_id: @conversation.id,
                            user_id: @message.sender_id,
                            message_id: @message.id,
                            notification_type: 'admin_message',
                            sender_id: @current_user.id,
                            sender_name: @current_user.username,
                            sender_image: @current_user.profile_image.present? ? @current_user.profile_image.blob.url : '')
        # render json: { report_details: { conversation: @conversation, message: @message } }
      end
    else
      render json: { message: "No conversation present" }, status: :not_found
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @blocked_user = BlockUser.find_by(blocked_user_id: @user.id, user_id: @current_user.id)
    if @user.present?
      if @blocked_user.present?
        @blocked_user.destroy
        # @conversation = Conversation.where(sender_id: @user.id, recipient_id: @current_user.id).or(Conversation.where(sender_id: @current_user.id, recipient_id: @user.id))
        # if @conversation.present?
        #   @conversation.update(is_blocked: false)
        # else
        #   render json: { message: "Conversation is not present" }
        # end
        render json: { message: "User has been unblocked" }
      else
        render json: { message: "This user is not blocked" }
      end
    else
      render json: { message: "This user does not exist" }
    end
  end

  def index
    @blocked_users = @current_user.blocked_users.paginate(page: params[:page], per_page: 25)
  end

  private

  def message_params
    params.permit(:body, :receiver_id, :admin_user_id, :subject, :message_ticket, message_images: []).merge(sender_id: @current_user.id, user_id: @current_user.id)
  end

  def find_user
    @user = User.find_by(id: params[:user_id])
  end

  def find_blocked_user
    @blocked_user = BlockUser.find_by(blocked_user_id: params[:block_user_id], user_id: @current_user.id)
  end

  def generate_ticket_number
    @ticket_number = loop do
      random_token = (SecureRandom.urlsafe_base64(6, false))
      break random_token unless Support.exists?(ticket_number: random_token)
    end
  end

  def render_message(message)
    {
      id: message.id,
      body: message.body,
      conversation_id: message.conversation_id,
      # sender_id: message.sender_id,
      # sender_name: message.sender.username,
      # receiver_id: message.conversation.receiver.id.present? ? message.conversation.receiver.id : '',
      # receiver_name: message.conversation.receiver.username,
      created_at: message.created_at,
      message_images_count:  message.message_images.count,
      message_images: message.message_images.map{|message_image| message_image.present? ? message_image.blob.url : ''} ,
      # sender_image: message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : '',
      # receiver_image: message.receiver.profile_image.attached? ? message.receiver.profile_image.blob.url : ''
    }
    end
end