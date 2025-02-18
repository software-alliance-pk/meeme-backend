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
      @badges = Badge.all
    elsif params[:key].to_i == 1
      @badges = Badge.all.Rarity1
    elsif params[:key].to_i == 2
      @badges = Badge.all.Rarity2
    elsif params[:key].to_i == 3
      @badges = Badge.all.Rarity3
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

  def show
    @badge = Badge.find_by(id: params[:id])
    return render json: { error: 'Badge not found' }, status: :not_found unless @badge.present?

    render json: { badge: @badge }, status: :ok
  end

  def current_user_badges_stats
    likes = User.find(@current_user.id).likes.where.not(post_id: nil).where(is_liked: true).count
    comments = @current_user.comments.count
    gain_follower = @current_user.followers.follower_added.count
    follow = Follower.where(follower_user_id:@current_user.id).count
    memes = @current_user.posts.count
    shared = @current_user.shared || 0
    explored = @current_user.explored || 0

    # To Culculate the Streat of Judging Post
    judge = 0
    current_streak = 0
    max_streak = 0
    @result = []
    @today_date = Time.zone.now.end_of_day.to_datetime
    60.times do |num|
      status = Like.where(created_at: (@today_date - num).beginning_of_day..(@today_date - num).end_of_day, is_judged: true, user_id: 52).where.not(post_id: nil).present?
      @result << status
      if status
        current_streak += 1
        max_streak = [max_streak, current_streak].max
      else
        current_streak = 0
      end
      judge = num
    end

      render json: [
        { value:likes, badge_type: "likeable_badge" },
        { value: comments, badge_type: "commentator_badge"},
        { value: gain_follower, badge_type: "gain_followers_badge" },
        { value: (follow/2), badge_type: "follower_badge"  },
        { value: memes, badge_type: "memes_badge" },
        { value: shared, badge_type: "sharer_badge"  },
        { value: explored, badge_type: "explore_guru_badge" },
        { value: memes, badge_type: "upload_photo_badge" },
        { current_streak: current_streak, value: current_streak, max_streak:max_streak, judge: judge ,badge_type: "judge_badge" },
      ], status: :ok
  end

  def current_user_badges
    @badges = @current_user.badges.uniq
    if @badges.present?
    else
      render json: { badges: [] }, status: :ok
    end
  end

  def current_user_locked_badges
    @user_badges = @current_user.badges.pluck(:id)
    @locked_badges = Badge.all
                      .order(:badge_type, Arel.sql('"limit" ASC')).uniq
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