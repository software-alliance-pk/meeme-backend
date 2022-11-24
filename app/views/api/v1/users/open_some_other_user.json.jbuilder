json.profile do
  json.user @user
  json.user_image @user.profile_image.attached? ? @user.profile_image.blob.url : ''
  json.followers  @user.followers.where(is_following: true).count
  json.following  Follower.where(is_following: true, follower_user_id: @user.id).count
  json.badges  []
  json.all_post_count @user.posts.count
  json.profile_posts @user.posts.each do |post|
    json.post_description post.description
    json.post_time post.created_at
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    json.post_likes post.likes.like.count
    json.post_dislikes post.likes.dislike.count
  end

end
