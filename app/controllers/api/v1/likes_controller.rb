class  Api::V1::LikesController <  Api::V1::ApiController
  before_action :authorize_request
  before_action :check_post_or_comment, only: [:create]

  def create
    if already_liked?(@type)
      dislike(@type)
    else
      like = @subject.likes.new(post_id: params[:post_id], comment_id: params[:comment_id],user_id: @current_user.id)
      if like.save
        render json: {
          message: "#{@current_user.username} liked #{@type} , #{@subject.description}"
        }, status: :ok
      end
    end
  end

  private

  def check_post_or_comment
    if params.key?(:post_id)
      @type = 'post'
      @subject = Post.find_by_id(params[:post_id])
      return render json: {
        message: 'Post not found against your request'
      }, status: :unprocessable_entity unless @subject.present?
    elsif params.key?(:comment_id)
      @type = 'comment'
      @subject = Comment.find_by_id(params[:comment_id])
      return render json: {
        message: 'Comment not found against your request'
      }, status: :unprocessable_entity unless @subject.present?
    end
  end

  def already_liked?(type)
    result = false
    if type == 'post'
      result = Like.where(post_id: params[:post_id],user_id: @current_user.id).exists?
    else
      result = Like.where(comment_id: params[:comment_id],user_id: @current_user.id).exists?
    end
    result
  end

  def dislike(type)
    if type == 'post'
      like = Like.find_by(post_id: params[:post_id],user_id: @current_user.id)
    else
      like = Like.find_by(comment_id: params[:comment_id],user_id: @current_user.id)
    end
    return unless like
    like.destroy
    render json: {
      message: "#{@current_user.username} unliked #{type}, #{@subject.description}"
    }, status: :ok
  end
end
