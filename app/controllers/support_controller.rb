class SupportController < ApplicationController
    def show_chat
        @conversation = Conversation.find_by(id: params[:conversation_id])
        if @conversation.present?
            @messages = @conversation.messages.all
        end
        if params[:name].present?
            @user = User.find_by(username: params[:name])
            @user_image = @user.profile_image.attached? ? url_for(@user.profile_image) : ActionController::Base.helpers.asset_path('user.png')
            @admin = AdminUser.find(params[:admin_id])
            @admin_image = @admin.admin_profile_image.attached? ? url_for(@admin.admin_profile_image) : ActionController::Base.helpers.asset_path('user.png')
        end
        respond_to do |format|
            format.json {render json: {messages: @messages, user_image: @user_image, admin_image: @admin_image, conversation: @conversation}}
        end
    end

    def get_profile_image
        if params[:name].present?
            @user = User.find_by(username: params[:name])
            @image = @user.profile_image.attached? ? url_for(@user.profile_image) : ActionController::Base.helpers.asset_path('user.png')
            respond_to do |format|
                format.json {render json: {image: @image}}
            end
        end
    end

    def create_message
        @conversation = Conversation.find_by(id: params[:conversation_id])
        @subject = @conversation.messages[0].subject
        if @conversation.present?
          @message = @conversation.messages.new(message_params)
          @message.subject = @subject
          if @message.save
            ActionCable.server.broadcast("conversation_#{params[:conversation_id]}", { title: "message created", body: @message.body })
            Notification.create(title:"Message from #{@message.admin_user.admin_user_name}",
                                body: @message.body,
                                conversation_id: @conversation.id,
                                user_id: params[:user_id],
                                message_id: @message.id)
          end
          redirect_to support_path
        else
          render json: { message: "No conversation present" }, status: :not_found
        end
    end

    def issue_resolved
        if params[:name].present?
            @user = User.find_by(username: params[:name])
            @message = Message.all.where(user_id: @user.id).limit(1)
            @conversation = Conversation.find(@message.first.conversation_id)
            @conversation.update(status: 2)
        end
    end

    private
    def message_params
        params.permit(:body, :receiver_id, :admin_user_id, :subject, :message_ticket, message_images: [])
    end
end