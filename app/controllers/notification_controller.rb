class NotificationController < ApplicationController
    def create_notification
        @notification = Notification.new(notification_params)
        if params[:send_all].present? && params[:send_all] == "on" && params[:send_date] == ""
            @notification.save
        elsif params[:send_all].present? && params[:send_all] == "on" && params[:send_date] != ""
            @now = Time.now.strftime("%F") 
            @date = params[:send_date]
            @days = (@date.to_date - @now.to_date).to_i
            PushNotificationBroadCastJob.set(wait: @days.days).perform_later(params[:body], params[:title], params[:send_date])
        end
    end

    private
    def notification_params
        params.permit(:title, :send_all, :body, :status, :alert, :user_id, :conversation_id, :message_id, :follow_request_id, :send_date).merge( sender_id: current_admin_user.id, sender_name: current_admin_user.admin_user_name,
                                                                                                                                                 sender_image: current_admin_user.admin_profile_image.present? ?  current_admin_user.admin_profile_image.blob.url : '')
    end
end