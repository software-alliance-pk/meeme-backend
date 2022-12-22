class Api::V1::BadgesController < Api::V1::ApiController
  before_action :authorize_request
  def index
    @badges=Badge.all
    if @badges.present?
    else
      render json: {badges: []}, status: :not_found
    end
  end

  def create
    @badge=Badge.create(badge_params)
    if @badge.save
      render json: {badge: @badge,
                    badge_image: @badge.badge_image.attached? ? @badge.badge_image.blob.url : ""}, status: :ok
    else
      render_error_messages(@badge)
    end
  end

  def current_user_badges
    @badges=@current_user.badges
    if @badges.present?
    else
      render json: {badges: []}, status: :not_found
    end
  end
  private
  def badge_params
    params.permit(:title,:badge_image)
  end
end