class TournamentLikeService

  def initialize(post_id, current_user_id)
    @post_id = post_id
    @current_user_id = current_user_id
  end

  def create_for_tournament
    if already_liked?
      if @result == true
        like = Like.find_by(post_id: @post_id, user_id: @current_user_id)
        return unless like
        like.destroy
        message = "UnlLiked"
        [like, message]
      end
    else
      like = Like.new(post_id: @post_id, user_id: @current_user_id, is_liked: true)
      like.save
      message = "Liked"
    end
    [like, message]
  end

  def already_liked?
    @result = false
    if @result = Like.where(post_id: @post_id, user_id: @current_user_id).exists?
      @result = true
    else
      @result
    end
  end
end