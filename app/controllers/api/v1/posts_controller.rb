class Api::V1::PostsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_post, only: [:show, :update_posts, :destroy]

  def index
    @posts = @current_user.posts.by_recently_created(20).paginate(page: params[:page], per_page: 25)
    if @posts.present?

    else
      render json: { message: "No posts for this particular user" }, status: :not_found
    end
  end

  def show
    render json: { post: @current_user.posts.by_recently_created },
           # post_image: @post.post_image.attached? ? @post.post_image.blob.url : '' },
           status: :ok
  end

  def create
    @post = @current_user.posts.new(post_params)
    if @post.save
      render json: { user: @post, post_image: @post.post_image.attached? ? @post.post_image.blob.url : '', message: 'Post created successfully' }, status: :ok
    else
      render_error_messages(@post)
    end
  end

  def update_posts
    unless @post.update(post_params)
      render_error_messages(@post)
    else
      @post.update(post_params)
      render json: { post: @post,
                     post_image: @post.post_image.attached? ? @post.post_image.blob.url : '',
                     message: "Post Updated" },
             status: :ok
    end
  end

  def destroy
    @post.destroy
    render json: { message: "Post successfully destroyed" }, status: :ok
  end

  def explore
    @tags = ActsAsTaggableOn::Tag.all.pluck(:name).uniq
    # @users = User.where("LOWER(username) LIKE ?", "%#{params[:username].downcase}%").all

    # if params[:search_bar] == "true"
      # if params[:username].empty?
      #   @users=[]
      # end
      # if params[:tag].empty?
      #   @users = User.where("LOWER(username) LIKE ?", "%#{params[:username].downcase}%").all
      # end
      # if params[:tag] == "#"
      #   @posts = Post.where(tournament_meme: false)
      #   @users = []
      # else
      #   @posts = Post.tagged_with(params[:tag])
      #   if @posts.present?
      #   else
      #     # @posts=Post.all.paginate(page: params[:page], per_page: 25)
      #     render json: { message: "No Post found against this tag " }, status: :not_found
      #   end
      # end


    # else
      if params[:tag] == "#"
        @posts = Post.where(tournament_meme: false)
        # @users = []
      else
        @posts = Post.tagged_with(params[:tag])
        if @posts.present?
        else
          # @posts=Post.all.paginate(page: params[:page], per_page: 25)
          render json: { message: "No Post found against this tag " }, status: :not_found
        end
      end
    # end
  end

  def other_posts
    @tags = ActsAsTaggableOn::Tag.all.pluck(:name).uniq
    @post = Post.find_by(id: params[:post_id])
    if params[:tag] == "#"
      @posts = Post.where(tournament_meme: false)
      # render json: { message: "Tag not found" }, status: :not_found
    else
      @posts = Post.tagged_with(params[:tag])
      @posts = @posts.where.not(id: @post.id)
      if @posts.present?
      else
        # @posts=Post.all.paginate(page: params[:page], per_page: 25)
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    end
  end

  def tags
    @tags = ActsAsTaggableOn::Tag.all.pluck(:name).uniq
    # @tags=@tags.paginate(page: params[:page], per_page: 25)
    render json: { tags: @tags }, status: :ok if @tags.present?
  end

  def following_posts
    @following = @current_user.followers.where(is_following: true).pluck(:follower_user_id)
    @following = User.where(id: @following).paginate(page: params[:page], per_page: 25)
  end

  def recent_posts
    @recent_posts = Post.where(tournament_meme: false).by_recently_updated(20).paginate(page: params[:page], per_page: 25)
  end

  def trending_posts
    @likes = Like.where(status: 1, is_liked: true, is_judged: false).joins(:post).where(post: { tournament_meme: false }).group(:post_id).count(:post_id).sort_by(&:last).reverse.to_h
    @trending_posts = Post.where(id: @likes.keys).paginate(page: params[:page], per_page: 25).reverse
    if @trending_posts

    end
  end

  private

  def find_post
    unless (@post = @current_user.posts.find_by(id: params[:post_id]))
      return render json: { message: 'Post Not found' }
    end
  end

  def post_params
    params.permit(:id, :description, :tag_list, :post_likes, :post_image, :user_id, :tournament_banner_id, :tournament_meme)
  end
end
