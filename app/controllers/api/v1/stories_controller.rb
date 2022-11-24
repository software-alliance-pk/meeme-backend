class Api::V1::StoriesController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_story, only: [:destroy, :like_dislike_a_story,:story_comment,:show_story_comments]
  before_action :find_valid_user, only: :destroy

  def index
    @story = Story.recently_created.paginate(page: params[:page], per_page: 25)
    if @story.present?
    else
      # return render json: { message: 'No stories found for this user' }, status: :not_found
    end
  end

  def create
    @story = @current_user.stories.new(story_params)
    if @story.save
      render json: @story, status: :ok
    else
      render_error_messages(@story)
    end
  end

  def destroy
    @story.destroy
    render json: { message: "Story successfully destroyed" }, status: :ok
  end

  def like_dislike_a_story
    response = StoryLikeService.new(params[:id], @current_user.id).create_for_story
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
      # render json: { message: "No comments has been made yet" }, status: :not_found
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
    params.permit(:id, :story_image).merge(user_id: @current_user.id)
  end

end