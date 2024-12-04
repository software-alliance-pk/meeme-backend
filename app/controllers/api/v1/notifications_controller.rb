class Api::V1::NotificationsController < Api::V1::ApiController
  before_action :authorize_request

  def user_notifications
    @notifications=@current_user.notifications.where(notification_type: [0,2,3,8,10,11]).order(created_at: :desc)
    @current_user.notifications.where(notification_type: [1,2,3,8]).update_all(status: 'read')
    @notifications=@notifications.group_by{ |x| x.created_at.strftime('%d,%m,%Y') }
    if @notifications.present?
    else
      render json: { user: @current_user, notifications: [] }, status: :ok
    end
  end

  def unread_count
    unread_count= @current_user.notifications.where(notification_type: [1,2,3,8], status:'un_read').count
    render json: { unread_notification_count: unread_count }, status: :ok
  end

  def change_opened_status
    notification = Notification.find(params[:notitification_id]) # Use singular Notification
    notification.update(is_opened: true)
    render json: { message: "Notification status changed successfully" }, status: :ok
  end

end
