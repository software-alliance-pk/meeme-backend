class Api::V1::StoriesController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_story, only: [:destroy, :like_dislike_a_story,:story_comment,:show_story_comments]
  before_action :find_valid_user, only: :destroy

  def index
    @story= Story.all.reverse.pluck(:user_id).uniq
    # @story = Story.recently_created.paginate(page: params[:page], per_page: 25)
    if @story.present?
    else
    end
  end

  def create
    @story = @current_user.stories.new(story_params)
    if @story.save
      StoryWorker.perform_in((Time.now + 24.hour), @story.id)
      render json: @story, status: :ok
    else
      render_error_messages(@story)
    end
  end

  def destroy
    @story.destroy
    render json: { message: "Story successfully deleted" }, status: :ok
  end

  def like_dislike_a_story
    response = StoryLikeService.new(@story.id, @current_user.id).create_for_story
    render json: { like: response[0], message: response[1] }, status: :ok if response
  end

  def story_comment
    @story_comment=@story.comments.new(description: params[:description],user_id: @current_user.id,story_id: @story.id)
    if @story_comment.save
      render json: {comments: @story_comment  }, status: :ok if @story_comment
    else
      render_error_messages(@story_comment)
    end
  end

  def show_story_comments
    @story_comment=@story.comments.paginate(page: params[:page], per_page: 25)
    if @story_comment.present?
    else
    end
  end

  private

  def find_story
    @story = Story.find_by(id: params[:story_id].to_i)
    unless (@story.present?)
      return render json: { message: 'Story Not found' }, status: :not_found
    end
  end

  def find_valid_user
    unless (@story.user == @current_user)
      return render json: { message: "You aren't allowed to delete this story" }, status: :not_found
    end
  end

  def story_params
    params.permit(:id, :story_image,:description).merge(user_id: @current_user.id)
  end

end