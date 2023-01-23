class Api::V1::CommentsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_post,only: [:create]
  before_action :find_comment, only: [:show, :update_comments, :destroy,:create_child_comment]
  before_action :find_child_comment, only: [:child_comments, :child_comment_destroy]

  def index
    @comments = Post.find_by(id: params[:post_id])
    if @comments.present?
      @comments = @comments.comments.where(parent_id: nil).paginate(page: params[:page], per_page: 25)
      if @comments.present?
      else
      end
    else
      render json: { message: "Post is not present" }, status: :not_found
    end

  end

  def child_comments
    @child_comment=@child_comment.paginate(page: params[:page], per_page: 25)
    if @child_comment.present?

    else
    end

  end

  def show
    render json: { comment: @current_user.comments },
           status: :ok
  end

  def create
    @comment = Post.find(params[:post_id]).comments.new(description: params[:description],
                                                        user_id: @current_user.id,
                                                        post_id: params[:post_id])
    if @comment.save
      Notification.create(title: "Comment",
                          body: "#{@current_user.username} commented on your post",
                          user_id: @comment.post.user.id,
                          notification_type: 'comment',
                          sender_id: @current_user.id,
                          sender_name: @current_user.username,
                          sender_image: @current_user.profile_image.present? ? @current_user.profile_image.blob.url : '')
      render json: { comment: @comment }, status: :ok
    else
      render_error_messages(@comment)
    end
  end

  def create_child_comment
    @comment = Post.find(params[:post_id]).comments.new(description: params[:description],
                                                        user_id: @current_user.id,
                                                        post_id: params[:post_id],
                                                        parent_id: params[:comment_id])
    if @comment.save
      render json: { comment: @comment }, status: :ok
      Notification.create(title: "Comment",
                          body: "#{@current_user.username} commented on your post",
                          user_id: @comment.post.user.id,
                          notification_type: 'comment',
                          sender_id: @current_user.id,
                          sender_name: @current_user.username,
                          sender_image: @current_user.profile_image.present? ? @current_user.profile_image.blob.url : '')
    else
      render_error_messages(@comment)
    end
  end

  def update_comments
    unless @comment.update(comment_params)
      render_error_messages(@comment)
    else
      @comment.update(comment_params)
      render json: { comment: @comment,
                     message: "Comment Updated" },
             status: :ok
    end
  end

  def update_child_comments
    @child_comment = Comment.find_by(id: params[:id])
    if @child_comment.present?
      unless @child_comment.update(comment_params)
        render_error_messages(@child_comment)
      else
        @child_comment.update(comment_params)
        render json: { child_comment: @child_comment,
                       message: "Child Comment Updated" },
               status: :ok
      end
    else
      return render json: { message: ' Child Comment Not found' }, status: :not_found
    end
  end

  def destroy
    @comment.destroy
    render json: { message: "Comment successfully destroyed" }, status: :ok
  end

  def child_comment_destroy
    @child_comment = Comment.find_by(id: params[:comment_id])
    if @child_comment.present?
      @child_comment.destroy
      render json: { message: "Child Comment successfully destroyed" }, status: :ok
    else
      render json: { message: "Child Comment not found" }, status: :not_found
    end
  end

  private
  def find_post
    @post=Post.find_by(id: params[:post_id]).present?
    if @post
    else
      return render json: { message: ' Post Not found' }, status: :not_found
    end
  end
  def find_comment
    if Post.find_by(id: params[:post_id]).present?
      if Post.find_by(id: params[:post_id]).comments.find_by(id: params[:comment_id]).present?
        unless (@comment = Post.find_by(id: params[:post_id]).comments.find_by(id: params[:comment_id]))
          return render json: { message: ' Comment Not found' }, status: :not_found
        end
      else
        return render json: { message: ' Comment not found' }, status: :not_found
      end
    else
      return render json: { message: ' Post Not found' }, status: :not_found
    end

  end

  def find_child_comment
    if Post.find_by(id: params[:post_id]).present?
      if Post.find_by(id: params[:post_id]).comments.find_by(id: params[:comment_id]).present?
        unless (@child_comment = Post.find_by(id: params[:post_id]).comments.find_by(id: params[:comment_id]).comments)
          return render json: { message: ' Child Comment Not found' }, status: :not_found
        end
      else
        return render json: { message: ' Comment not found' }, status: :not_found
      end
    else
      return render json: { message: ' Post Not found' }, status: :not_found
    end
  end

  def comment_params
    params.permit(:id, :description, :comment_likes, :post_id, :user_id)
  end
end
