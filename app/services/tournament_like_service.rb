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
        # like.destroy
        coins = User.find(@current_user_id).coins
        message = "You have already locked your option as liked"
        [like, message, coins]
      end
    else
      like = Like.new(post_id: @post_id, user_id: @current_user_id, is_liked: true)
      like.save
      coins = +50
      user_coin = User.find(@current_user_id).coins
      coins += user_coin
      User.find(@current_user_id).update(coins: coins)
      message = "Liked 50 coins added"
    end
    [like, message, coins]
  end

  def dislike_for_tournament
    if already_liked?
      if @result == true
        like = Like.find_by(post_id: @post_id, user_id: @current_user_id)
        return unless like
        # like.destroy
        coins = User.find(@current_user_id).coins
        message = "You have already locked your option as liked"
        [like, message, coins]
      end
    else
      like = Like.new(post_id: @post_id, user_id: @current_user_id, is_liked: false)
      like.save
      coins = +50
      user_coin = User.find(@current_user_id).coins
      coins += user_coin
      User.find(@current_user_id).update(coins: coins)
      message = "DisLiked added 50 coins in your wallet"
    end
    [like, message, coins]
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