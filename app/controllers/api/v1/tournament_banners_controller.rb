class Api::V1::TournamentBannersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_tournament ,except: [:create_tournament]
  before_action :check_expiration, except: [:create_tournament]
  before_action :check_user_is_in_tournament, only: [:enroll_in_tournament]
  before_action :find_post, only: [:forwarding_memee_to_tournament]
  before_action :find_tournament_rule, only: :show_tournament_rules

  def index
    render json: { tournament: @tournament,
                   tournament_banner_image: @tournament.tournament_banner_photo.attached? ? @tournament.tournament_banner_photo.blob.url : '',
                   tournament_users_count: @tournament.tournament_users.count,
                   tournament_posts_count: @tournament.posts.count,
                   is_current_user_enrolled: @tournament.users.find_by(id: @current_user.id).present?
    }, status: :ok
  end

  def tournament_posts
    @tournament_posts = @tournament.posts.where.not(user_id: @current_user.id).paginate(page: params[:page], per_page: 25)
    if @tournament_posts.present?
    else
    end
  end

  def tournament_winner
    @result = []
    @tournament_posts = Like.joins(:post).where(post: { tournament_banner_id: @tournament.id, tournament_meme: true }).group(:post_id).count(:post_id).sort_by(&:last).to_h
    @tournament_posts = @tournament_posts.each do |k, v|
      if v == @tournament_posts.values.max
        @result.push(Post.find(k))
      end
    end
    if @result.present?

    end
  end

  def top_10_positions
    @username = []
    @post_like = []
    @all_user = {}
    @tournament_posts = Like.joins(:post).where(post: { tournament_banner_id: @tournament.id, tournament_meme: true }).group(:post_id).count(:post_id).sort_by(&:last).to_h
    @tournament_posts = @tournament_posts.group_by { |k, v| v }
    @tournament_posts.keys.each do |key|
      key_value = @tournament_posts[key]
      key_value.each do |row, col|
        @username << Post.find(row).user.username
      end
      @all_user[key] = @username
      @username = []
      @post_like = []
    end
    @all_user = @all_user.to_a.reverse
    render json: { tournament_name: @tournament.title, username_with_position: @all_user.each_with_index.map { |a, index| "#{a[1]} is at position #{index + 1}" } }

  end

  def enroll_in_tournament
    @tournament_user = @tournament.tournament_users.new(tournament_entry_params)
    if @tournament_user.save
      render json: { message: "#{@current_user.username} has enrolled in #{@tournament.title}", status: true }
    else
      render_error_messages(@tournament_user)
    end
  end

  def create
    @tournament_post = Post.new(post_params)
    if @tournament.tournament_users.find_by(user_id: @current_user.id).present?
      @tournament_post.tags_which_duplicate_tag = params[:tag_list]
      if @tournament_post.save
        @tags = @tournament_post.tag_list.map { |item| item&.split("dup")&.first }
        if @tournament_post.post_image.attached? && @tournament_post.post_image.video?
          @tournament_post.update(duplicate_tags: @tags, thumbnail: @tournament_post.post_image.preview(resize_to_limit: [100, 100]).processed.url)
        else
          @tournament_post.update(duplicate_tags: @tags)
        end
        render json: { tournament: @tournament_post.attributes.except('tag_list'),
                       tournament_banner_image: @tournament_post.post_image.attached? ? @tournament_post.post_image.blob.url : '',
                       tournament_banner_image_content_type: @tournament_post.post_image.content_type
        }, status: :ok
        PostBadgeJob.perform_now(@tournament_post)
      else
        render_error_messages(@tournament_post)
      end
    else
      render json: { message: "User is not enrolled in tournament" }, status: :not_found
    end
  end

  def create_tournament
    @tournament_banner = TournamentBanner.create!(title: params[:title], start_date: params[:start_date], end_date: params[:end_date])
    @today_date = Time.zone.now.end_of_day.to_datetime
    @tournament_end_date = @tournament_banner.end_date.strftime("%a, %d %b %Y").to_datetime
    @tournamnet_days = (@tournament_end_date - @today_date).to_i
    TournamentWorker.perform_in((Time.now + @tournamnet_days.days), @tournament_banner.id)
    render json: { tournament_banner: @tournament_banner }, status: :ok
  end

  def like_unlike_a_tournament_post
    if @tournament.posts.find_by(id: params[:post_id]).present?
      if @tournament.tournament_users.find_by(user_id: @current_user.id).present?
        response = TournamentLikeService.new(params[:post_id], @current_user.id).create_for_tournament
        render json: { like: response[0], message: response[1], coin: response[2], check: response[3] }, status: :ok
      else
        render json: { message: "User is not enrolled in this tournament" }, status: :not_found
      end
    else
      render json: { message: "Post is not in this tournament" }, status: :not_found
    end
  end

  
# To like and Dislike the post creatd in Tournament
  def dislike_a_tournament_post
    if @tournament.posts.find_by(id: params[:post_id]).present?
      if @tournament.tournament_users.find_by(user_id: @current_user.id).present?
        response = TournamentLikeService.new(params[:post_id], @current_user.id).dislike_for_tournament
        render json: { like: response[0], message: response[1], coin: response[2], check: response[3] }, status: :ok
      else
        render json: { message: "User is not enrolled in this tournament" }, status: :not_found
      end
    else
      render json: { message: "Post is not in this tournament" }, status: :not_found
    end
  end

  def judge
    @milstone_check = false
    @today_date = Time.zone.now.end_of_day.to_datetime
    @tournament_end_date = @tournament.end_date.strftime("%a, %d %b %Y").to_datetime
    @tournament_start_date = @tournament.start_date.strftime("%a, %d %b %Y").to_datetime
    # @difference = (@tournament_end_date - @tournament_start_date).to_i
    @tournamnet_days = (@tournament_end_date - @tournament_start_date).to_i
    @difference = (@today_date - @tournament_start_date).to_i
    if ((@tournament_end_date <= @today_date) | (@tournament.enable == false))
      return render json: { message: "Tournament Ended" }, status: :ok
    else
      @posts_judged = Like.where(created_at: (@tournament_start_date).beginning_of_day..(@tournament_end_date).end_of_day, is_judged: true, user_id: @current_user.id).where.not(post_id: nil) if present?
    end
  end

  def show_tournament_rules
    render json: { tournament_rules: @tournament_rules }, status: :ok
  end

  def show_tournament_prices
    @tournament = @tournament.ranking_price
    return render json: { rules: @tournament }, status: :ok if @tournament
  end

  def forwarding_memee_to_tournament
    return render json: { message: 'User Must Join Tournament First' }, status: :unauthorized unless @tournament.tournament_users.find_by(user_id: @current_user.id).present?

    @tournament_meme = Post.create(post_params)
    @tournament_meme.description = @post.description
    @tournament_meme.duplicate_tags = @post.duplicate_tags
    @tournament_meme.share_count = @post.share_count
    @tournament_meme.thumbnail = @post.thumbnail
    TournamentBanner.add_image(@post.post_image.blob.url, @tournament_meme)
    # @tournament_meme.post_image.attach(io: URI.parse(@post.compress_image).open, filename: 'meme_image')
    @tournament_meme.compress_image = @post.compress_image
    @tournament_meme.tag_list = @post.tag_list
    return render_error_messages(@tournament_meme) unless @tournament_meme.save

    render json: { forwarded_meme: @tournament_meme, post_type: @tournament_meme.post_image.content_type, message: 'Meme Forwarded Successfully' }, status: :ok
  end

  private

  def find_tournament
    unless (@tournament = TournamentBanner.where(enable: true)
      .where('end_date > ?', Time.zone.now.end_of_day)
      .first)
      return render json: { message: 'No Tournament is played at the moment' }, status: :not_found
    end
  end

  def check_expiration
      @today_date = Time.zone.now.end_of_day.to_datetime
      if @tournament.end_date <= @today_date
        return render json: { message: 'No Tournament is played at the moment' }, status: :not_found
      end
  end

  #
  def post_params
    params.permit(:id, :tag_list, :description, :post_image, :created_at, :updated_at).merge(user_id: @current_user.id, tournament_meme: true, tournament_banner_id: @tournament.id)
  end

  def tournament_entry_params
    params.permit(:id).merge(user_id: @current_user.id, tournament_banner_id: @tournament.id)
  end

  def check_user_is_in_tournament
    if (@tournament.tournament_users.find_by(user_id: @current_user.id).present?)
      return render json: { message: 'Already enrolled', status: false }, status: :ok
    end
  end

  def find_post
    @post = Post.find_by(id: params[:post_id])
    return render json: { message: 'Post not found' }, status: :bad_request unless @post.present?
  end

  def find_tournament_rule
    return render json: { message: "Tournament not found" }, status: :not_found unless (@tournament = TournamentBanner.find_by(id: params[:id]))

    return render json: { message: 'No rules added for this tournament' }, status: :not_found unless (@tournament_rules = @tournament.tournament_banner_rule)
  end
end
