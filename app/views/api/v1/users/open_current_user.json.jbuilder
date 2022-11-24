json.profile do
  json.user @current_user
  json.user_image @current_user.profile_image.attached? ? @current_user.profile_image.blob.url : ''
  json.followers  @current_user.followers.where(is_following: true).count
  json.following  Follower.where(is_following: true, follower_user_id: @current_user.id).count
  json.badges  []
  json.all_post_count @current_user.posts.count
  json.post_count @current_user.posts.where(tournament_meme:false).count
  json.profile_posts @current_user.posts.where(tournament_meme: false).each do |post|
    json.post_description post.description
    json.post_time post.created_at
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    # json.post_likes post.likes.count
    json.post_likes post.likes.where(status: 1).count
    json.post_dislikes post.likes.where(status: 2).count
    # json.post_comments_count post.comments.count
    # json.post_comments post.comments.each do |comment|
    #   json.id comment.id
    #   json.description comment.description
    #   json.parent_id comment.parent_id
    #   json.comment_likes comment.likes.count
    #   json.child_comments_count comment.comments.count
    #   # json.child_comments comment.comments.each do |child_comment|
    #   #   json.id child_comment.id
    #   #   json.description child_comment.description
    #   #   json.parent_id child_comment.parent_id
    #   #   json.child_comment_likes child_comment.likes.count
    #   # end
    # end
  end
  json.tournament_posts_count @current_user.posts.where(tournament_meme: true).count
  json.tournament_posts @current_user.posts.where(tournament_meme: true).each do |post|
    json.post_description post.description
    json.post_time post.created_at
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    json.post_likes post.likes.where(status: 1).count
    json.post_dislikes post.likes.where(status: 2).count

    # json.post_comments_count post.comments.count
    # json.post_comments post.comments.each do |comment|
    #   json.id comment.id
    #   json.description comment.description
    #   json.parent_id comment.parent_id
    #   json.comment_likes comment.likes.count
    #   json.child_comments_count comment.comments.count
    #   # json.child_comments comment.comments.each do |child_comment|
    #   #   json.id child_comment.id
    #   #   json.description child_comment.description
    #   #   json.parent_id child_comment.parent_id
    #   #   json.child_comment_likes child_comment.likes.count
    #   # end
    # end
  end

end
