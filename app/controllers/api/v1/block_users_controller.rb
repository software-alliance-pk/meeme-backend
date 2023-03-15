class Api::V1::BlockUsersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_user, only: [:create]
  before_action :find_blocked_user, only: [:create]

  def create
    if params[:type] == "block"
      if @user.present?
        return render json: { message: "User is already blocked"} unless !@blocked_user.present?
        @block_user = BlockUser.create(blocked_user_id: params[:block_user_id], blocked_by_id: @current_user.id)
        # @conversation = Conversation.where(sender_id: params[:block_user_id], recipient_id: @current_user.id).or(Conversation.where(sender_id: @current_user.id, recipient_id: params[:block_user_id]))
        # if @conversation.present?
        #   @conversation.update(is_blocked: true)
        # else
        #   render json: { message: "User and conversation has been blocked" }
        # end
      else
        render json: { message: "This user does not exist" }
      end
    elsif params[:type] == "report"
      @support = @current_user.supports.new(supports_params.merge(ticket_number: generate_ticket_number.upcase, description: "Report"))
      if @support.save
        @conversation = Conversation.create(support_id: @support.id, recipient_id: Admin.admin.id, sender_id: @support.user_id)
        @message = UserSupportMessage.create(support_conversation_id: @conversation.id, body: "#{params[:user_name]} has been reported by #{@current_user.first_name + ' ' + @current_user.last_name}", sender_id: @support.user_id )
      else
        render json: {
          message: 'There are errors while creating support query',
          error: @support.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @blocked_user = BlockUser.find_by(blocked_user_id: @user.id, blocked_by_id: @current_user.id)
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
    @blocked_users = @current_user.blocked_users
  end

  private

  def find_user
    @user = User.find_by(id: params[:block_user_id])
  end

  def find_blocked_user
    @blocked_user = BlockUser.find_by(blocked_user_id: params[:block_user_id], blocked_by_id: @current_user.id)
  end

  def generate_ticket_number
    @ticket_number = loop do
      random_token = (SecureRandom.urlsafe_base64(6, false))
      break random_token unless Support.exists?(ticket_number: random_token)
    end
  end
end