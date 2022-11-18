json.profile do
  json.user @user.attributes.except('coins')
  json.user_image @user.profile_image.attached? ? @user.profile_image.blob.url : ''
  json.post_count @user.posts.count
  json.followers  @user.followers.where(is_following: true).count
  json.following  Follower.where(is_following: true, follower_user_id: @user.id).count
  json.tournament_posts  []
  json.badges  []
  json.profile_posts @user.posts.each do |post|
    json.post_description post.description
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''

    # json.post_likes post.likes.count
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
