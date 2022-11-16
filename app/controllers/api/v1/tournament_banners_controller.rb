class Api::V1::TournamentBannersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_tournament

  def index
    render json: { tournament: @tournament,
                   tournament_banner_image: @tournament.tournament_banner_photo.attached? ? @tournament.tournament_banner_photo.blob.url : '',
                   tournament_users_count: @tournament.tournament_users.count,
                   tournament_posts_count: @tournament.posts.count
    }, status: :ok
  end

  def enroll_in_tournament
    @tournament_user=@tournament.tournament_users.new(tournament_entry_params)
    if @tournament_user.save
      render json: {message: "#{@current_user.username} has enrolled in #{@tournament.title}"}
    else
      render_error_messages(@tournament_user)
    end
  end

  def create
    @tournament_post = Post.new(post_params)
    debugger
    if @tournament.tournament_users.find_by(id: @current_user.id).present?
      if @tournament_post.save
        render json: { tournament: @tournament_post,
                       tournament_banner_image: @tournament_post.post_image.attached? ? @tournament_post.post_image.blob.url : '',
        }, status: :ok
      else
        render_error_messages(@tournament_post)
      end
    else
      render json: { message: "User is not enrolled in tournament" }
    end
  end

  def update_posts

  end

  private

  def find_tournament
    unless (@tournament = TournamentBanner.find_by(enable: true))
      return render json: { message: 'No Tournament is played at the moment' }, status: :not_found
    end
  end

  #
  def post_params
    params.permit(:id, :description, :tags, :created_at, :updated_at).merge(user_id: @current_user.id, tournament_meme: true, tournament_banner_id: @tournament.id)
  end

  def tournament_entry_params
    params.permit(:id).merge(user_id: @current_user.id,tournament_banner_id: @tournament.id)
  end
end
