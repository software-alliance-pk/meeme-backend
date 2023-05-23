class SupportController < ApplicationController
    def show_chat
        @conversation = Conversation.find_by(id: params[:conversation_id])
        if @conversation.present?
            @messages = @conversation.messages.all
            @image = []
            @all_images_array = []
            @conversation.messages.each do |message|
                if message.message_images.attached?
                    message.message_images.blobs.each do |image|
                        @image << CloudfrontUrlService.new(image).admin_urls
                    end
                else
                    @image << ""
                end
                @all_images_array << @image
                @image = []
            end
        end
        if params[:email].present?
            @user = User.find_by(email: params[:email])
            @user_image = @user.profile_image.attached? ? CloudfrontUrlService.new(@user.profile_image).cloudfront_url : ActionController::Base.helpers.asset_path('user.png')
            @admin = AdminUser.find(params[:admin_id])
            @admin_image = @admin.admin_profile_image.attached? ? CloudfrontUrlService.new(@admin.admin_profile_image).cloudfront_url : ActionController::Base.helpers.asset_path('user.png')
        end
        respond_to do |format|
            format.json {render json: {messages: @messages, images: @all_images_array, user_image: @user_image, admin_image: @admin_image, conversation: @conversation}}
        end
    end

    def get_profile_image
        if params[:email].present?
            @user = User.find_by(email: params[:email])
            @image = @user.profile_image.attached? ? CloudfrontUrlService.new(@user.profile_image).cloudfront_url : ActionController::Base.helpers.asset_path('user.png')
            respond_to do |format|
                format.json {render json: {image: @image}}
            end
        end
    end

    def create_message
        @conversation = Conversation.find_by(id: params[:conversation_id])
        @subject = @conversation.messages[0].subject
        @message_ticket=@conversation.messages[0].message_ticket
        if @conversation.present?
            @message = @conversation.messages.new(message_params)
            @message.subject = @subject
            @message.message_ticket = @message_ticket
            @message.user_id = params[:user_id]
            if @message.save
                ActionCable.server.broadcast("conversation_#{params[:conversation_id]}", { title: "message created", body: render_message(@message) })
                Notification.create(title:"Message from #{@message.admin_user.admin_user_name}",
                                    body: @message.body,
                                    conversation_id: @conversation.id,
                                    user_id: params[:user_id],
                                    message_id: @message.id,
                                    sender_id: current_admin_user.id,
                                    sender_name: current_admin_user.admin_user_name,
                                    sender_image: current_admin_user.admin_profile_image.present? ?  CloudfrontUrlService.new(current_admin_user.admin_profile_image).cloudfront_url : '')
            end
        else
            render json: { message: "No conversation present" }, status: :not_found
        end
    end

    def issue_resolved
        if params[:message_ticket].present?
            @message = Message.where(message_ticket: params[:message_ticket]).limit(1)
            @conversation = Conversation.find(@message.first.conversation_id)
            @conversation.update(status: 2)
        end
    end

    private
    def message_params
        params.permit(:body, :receiver_id, :admin_user_id, :subject ,:message_ticket, message_images: [])
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
          message_images: message.message_images.map{|message_image| message_image.present? ? CloudfrontUrlService.new(message_image).cloudfront_url : ''} ,
          # sender_image: message.sender.profile_image.attached? ? message.sender.profile_image.blob.url : '',
          # receiver_image: message.receiver.profile_image.attached? ? message.receiver.profile_image.blob.url : ''
        }
    end

end