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
    if likes.present?
      render json: [
        { likes:likes, badge_type: "likeable_badge" },
        { comments: comments, badge_type: "commentator_badge"},
        { gain_follower: gain_follower, badge_type: "gain_followers_badge" },
        { follow: (follow/2), badge_type: "follower_badge"  },
        { memes: memes, badge_type: "memes_badge" },
        { shared: shared, badge_type: "sharer_badge"  },
        { explored: explored, badge_type: "explore_guru_badge" },
        { uploaded_photo: memes, badge_type: "upload_photo_badge" },
      ], status: :ok
    else
      render json: { badges: [] }, status: :ok
    end
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
    @locked_badges = Badge.where.not(id: @user_badges).uniq
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