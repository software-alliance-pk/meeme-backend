class Api::V1::PostsController < Api::V1::ApiController
  before_action :authorize_request

  def index
    @posts = @current_user.posts
    if @posts.present?
      # render index, status: :ok
    else
      render json: { message: "No posts for this particular user" }, status: :not_found
    end
  end

  def show
    render json: { post: @current_user.posts },
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
    @post = @current_user.posts.find(params[:post_id])
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
    begin
      @post = @current_user.posts.find(params[:post_id])
      @post.destroy
      render json: { message: "Post successfully destroyed" }, status: :ok
    rescue
      render json: { message: "Post not found" }, status: :unauthorized
    end

  end

  private

  def post_params
    params.permit(:id, :description, :tags, :post_likes, :post_image, :user_id)
  end
end
