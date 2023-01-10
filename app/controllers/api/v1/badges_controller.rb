class Api::V1::BadgesController < Api::V1::ApiController
  before_action :authorize_request

  def index
    @badges = Badge.all
    if @badges.present?
    else
      render json: { badges: [] }, status: :ok
    end
  end

  def all_badges
    if params[:key].to_i == 0
      @badges = Badge.all.limit(5)
    elsif params[:key].to_i == 1
      @badges = Badge.all.Rarity1.limit(5)
    elsif params[:key].to_i == 2
      @badges = Badge.all.Rarity2.limit(5)
    elsif params[:key].to_i == 3
      @badges = Badge.all.Rarity3.limit(5)
    end
    if @badges.present?
    else
      render json: { badges: [] }, status: :ok
    end
  end

  def create
    @badge = Badge.create(badge_params)
    if @badge.save
      render json: { badge: @badge,
                     badge_image: @badge.badge_image.attached? ? @badge.badge_image.blob.url : "" }, status: :ok
    else
      render_error_messages(@badge)
    end
  end

  def update_badge
    @badge = Badge.find_by(id: params[:id])
    if @badge.present?
      @badge.update(badge_params)
      render json: { badge: @badge,
                     badge_image: @badge.badge_image.attached? ? @badge.badge_image.blob.url : "" }, status: :ok
    else
      render_error_messages(@badge)
    end
  end

  def current_user_badges
    @badges = @current_user.badges.uniq
    debugger
    if @badges.present?
    else
      render json: { badges: [] }, status: :ok
    end
  end

  def current_user_locked_badges
    @user_badges = @current_user.badges.pluck(:id)
    @locked_badges = Badge.where.not(id: @user_badges).limit(5).uniq
    if @locked_badges.present?
    else
      render json: { badges: [] }, status: :ok
    end
  end

  def rarity_1_badges
    @badges = Badge.all.Rarity1
    if @badges.present?
    else
      render json: { badges: [] }, status: :ok
    end
  end

  def rarity_2_badges
    @badges = Badge.all.Rarity2
    if @badges.present?
    else
      render json: { badges: [] }, status: :ok
    end
  end

  def rarity_3_badges
    @badges = Badge.all.Rarity3
    if @badges.present?
    else
      render json: { badges: [] }, status: :ok
    end
  end

  def badge_rarity_search
    @badges = Badge.where("LOWER (title) LIKE ?", "%#{params[:title].downcase}%").all
    if @badges.present?
    else
      render json: { badges: [] }, status: :ok
    end
  end

  private

  def badge_params
    params.permit(:title, :badge_image, :rarity)
  end
end