class Api::V1::NotificationsController < Api::V1::ApiController
  before_action :authorize_request

  def user_notifications
    @notifications=@current_user.notifications.where(notification_type: [2,3,8]).reverse
    if @notifications.present?
      render json: { user: @current_user,notification_count: @notifications.count, notifications: @notifications }, status: :ok
    else
      render json: { user: @current_user, notifications: [] }, status: :ok
    end
  end
end
