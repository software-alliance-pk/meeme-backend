class Api::V1::TournamentBannersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_tournament
  before_action :check_user_is_in_tournament, only: [:enroll_in_tournament]

  def index
    render json: { tournament: @tournament,
                   tournament_banner_image: @tournament.tournament_banner_photo.attached? ? @tournament.tournament_banner_photo.blob.url : '',
                   tournament_users_count: @tournament.tournament_users.count,
                   tournament_posts_count: @tournament.posts.count,
                   is_current_user_enrolled: @tournament.users.find_by(id: @current_user.id).present?
    }, status: :ok
  end

  def tournament_posts
    @tournament_posts = @tournament.posts.paginate(page: params[:page], per_page: 25)
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
    @all_user={}
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
    @all_user=@all_user.to_a.reverse
    render json: {tournament_name: @tournament.title,username_with_position: @all_user.each_with_index.map{|a,index| "#{a[1]} is at position #{index+1}" }}

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
        @tournament_post.update(duplicate_tags: @tags)
        render json: { tournament: @tournament_post.attributes.except('tag_list'),
                       tournament_banner_image: @tournament_post.post_image.attached? ? @tournament_post.post_image.blob.url : '',
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
    @difference = (@tournament_end_date - @tournament_start_date).to_i
    if (@tournament_end_date == @today_date) | @tournament.enable == false
      return render json: { message: "Tournament Ended" }, status: :ok
    else
      @posts_judged = Like.where(created_at: (@tournament_start_date).beginning_of_day..(@tournament_end_date).end_of_day, is_judged: true, user_id: @current_user.id).where.not(post_id: nil) if present?
    end
  end

  def show_tournament_rules
    @tournament_rule = @tournament.tournament_banner_rule
    return render json: { rules: @tournament_rule }, status: :ok if @tournament_rule
  end

  def show_tournament_prices
    @tournament = @tournament.ranking_price
    return render json: { rules: @tournament }, status: :ok if @tournament
  end

  private

  def find_tournament
    unless (@tournament = TournamentBanner.find_by(enable: true))
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
end
