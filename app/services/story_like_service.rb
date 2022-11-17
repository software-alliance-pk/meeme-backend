class StoryLikeService

  def initialize(story_id, current_user_id)
    @story_id = story_id
    @current_user_id = current_user_id
  end

  def create_for_story
    if already_liked?
      if @result == true
        like = Like.find_by(story_id: @story_id, user_id: @current_user_id)
        return unless like
        like.destroy
        message = "UnlLiked"
        [like, message]
      end
    else
      like = Like.new(story_id: @story_id, user_id: @current_user_id, is_liked: true)
      like.save
      message = "Liked"
    end
    [like, message]
  end

  def already_liked?
    @result = false
    if @result = Like.where(story_id: @story_id, user_id: @current_user_id).exists?
      @result = true
    else
      @result
    end
  end
end