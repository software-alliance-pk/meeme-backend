class Api::V1::PostsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_post, only: [:show, :update_posts, :destroy]

  def index
    @posts = @current_user.posts.by_recently_created(20).paginate(page: params[:page], per_page: 25).shuffle
    if @posts.present?

    else
      render json: { message: "No posts for this particular user" }, status: :not_found
    end
  end

  def show
    render json: { post: @current_user.posts.by_recently_created },
           status: :ok
  end

  def create
    @post = @current_user.posts.new(post_params)
    @post.tags_which_duplicate_tag = params[:tag_list]
    if @post.save
      @tags = @post.tag_list.map { |item| item&.split("dup")&.first }
      if @post.post_image.attached? && @post.post_image.video?
        @post.update(duplicate_tags: @tags, thumbnail: @post.post_image.preview(resize_to_limit: [100, 100]).processed.url)
      else
        @post.update(duplicate_tags: @tags)
      end
      render json: { user: @post.attributes.except('tag_list'), post_image: @post.post_image.attached? ? @post.post_image.blob.url : '', post_type: @post.post_image.content_type, message: 'Post created successfully' }, status: :ok
    else
      render_error_messages(@post)
    end
  end

  def update_posts
    @post.tags_which_duplicate_tag = params[:tag_list]
    unless @post.update(post_params)
      render_error_messages(@post)
    else
      @tags = @post.tag_list.map { |item| item&.split("dup")&.first }
      @post.update(post_params)
      @post.update(duplicate_tags: @tags) if @tags.present?
      if params[:post_image].present?
        if params[:post_image].content_type[0..4]=="video"
          @post.update(thumbnail: @post.post_image.preview(resize_to_limit: [100, 100]).processed.url)
        else
          @post.update(thumbnail: nil)
        end
      end
      render json: { post: @post.attributes.except('tag_list'),
                     post_image: @post.post_image.attached? ? @post.post_image.blob.url : '',
                     post_type: @post.post_image.content_type,
                     message: "Post Updated" },
             status: :ok
    end
  end

  def destroy
    @post.delete
    render json: { message: "Post successfully deleted" }, status: :ok
  end

  def explore
    @tags = ActsAsTaggableOn::Tag.all.pluck(:name).map { |item| item.split("dup").first }.uniq
    if params[:tag] == ""
      @posts = Post.where(tournament_meme: false)
    else
      @posts = Post.tagged_with(params[:tag], :any => true)
      if @posts.present?
      else
        # @posts=Post.all.paginate(page: params[:page], per_page: 25)
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    end
  end

  def user_search_tag
    @posts = []
    @tags = ActsAsTaggableOn::Tag.all.pluck(:name).map { |item| item.split("dup").first }.uniq
    if params[:tag].empty?
      @users = User.where("LOWER(username) LIKE ?", "%#{params[:username].downcase}%").all
      if @users.present?
      end
    elsif params[:tag] == "#"
      @posts = Post.where(tournament_meme: false)
      @users = []

    else
      @posts = Post.tagged_with(params[:tag], :any => true)
      if @posts.present?
      else
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    end

  end

  def other_posts
    @tags = ActsAsTaggableOn::Tag.all.pluck(:name).uniq
    @post = Post.find_by(id: params[:post_id])
    if params[:tag] == "#"
      @posts = Post.where(tournament_meme: false)
    else
      @posts = Post.tagged_with(params[:tag])
      @posts = @posts.where.not(id: @post.id)
      if @posts.present?
      else
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    end
  end

  def tags
    @tags = ActsAsTaggableOn::Tag.all.pluck(:name).map { |item| item.split("dup").first }.uniq
    if @tags.present?
      render json: { tags: @tags }, status: :ok
    else
      render json: { tags: [] }, status: :ok
    end
  end

  def following_posts
    @following_posts = []
    @following = @current_user.followers.where(is_following: true).pluck(:follower_user_id)
    @following = User.where(id: @following).paginate(page: params[:page], per_page: 25)
    @following.each do |user|
      user.posts.where(tournament_meme: false).each do |post|
        @following_posts << post
      end
    end
    @following_posts = @following_posts.shuffle
    if @following_posts.present?
    else
      render json: { following_posts: [], following_count: @following.count }, status: :ok
    end
  end

  def recent_posts
    @recent_posts = Post.where.not(tournament_meme: true).by_recently_created(25).paginate(page: params[:page], per_page: 25)
    # @today_post = Post.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where.not(tournament_meme: true).by_recently_created(25).paginate(page: params[:page], per_page: 25)
    # @random_posts = Post.where.not(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where.not(tournament_meme: true).paginate(page: params[:page], per_page: 25).shuffle
    # @recent_posts = @today_post + @random_posts
    # @recent_posts = Post.where(tournament_meme: false).by_recently_created(20).paginate(page: params[:page], per_page: 25).shuffle
  end

  def trending_posts
    @trending_posts = []
    @likes = Like.where(status: 1, is_liked: true, is_judged: false).joins(:post).where(post: { tournament_meme: false }).group(:post_id).count(:post_id).sort_by(&:last).reverse.to_h
    @likes.keys.each do |key|
      @trending_posts << [Post.find_by(id: key), (Post.find_by(id: key).comments.count + Post.find_by(id: key).comments.count)]
    end
    @trending_posts = (@trending_posts.to_h).sort_by { |k, v| v }.reverse.paginate(page: params[:page], per_page: 25)
    # @trending_posts=@trending_posts.paginate(page: params[:page], per_page: 25)
    # @trending_posts = Post.where(id: @likes.keys).paginate(page: params[:page], per_page: 25)
    if @trending_posts

    end
  end

  def share_post
    @share_post = Post.find_by(id: params[:post_id])
    if @share_post.present?
      if @share_post.tournament_meme == true
        render json: { message: 'Tournament Posts cannot be shared', post: [], share_count: @share_post.share_count }, status: :ok
      else
        count = @share_post.share_count + 1
        @share_post.update_columns(share_count: count)
        ShareBadgeJob.perform_now(@share_post, @current_user)
        render json: { message: 'Tournament Posts Shared', post: @share_post, share_count: @share_post.share_count }, status: :ok
      end
    else
      render json: { message: 'Post not found' }, status: :not_found
    end

  end

  private

  def find_post
    unless (@post = @current_user.posts.find_by(id: params[:post_id]))
      return render json: { message: 'Post Not found' }
    end
  end

  def post_params
    params.permit(:id, :description, :tag_list, :post_likes, :post_image, :user_id, :tournament_banner_id, :tournament_meme, :duplicate_tags, :share_count, :thumbnail)
  end
end
