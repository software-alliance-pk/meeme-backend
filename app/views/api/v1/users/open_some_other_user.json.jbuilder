json.profile do
  json.user @user
  json.user_image @user.profile_image.attached? ? @user.profile_image.blob.url : ''
  if @current_user.id==@user.id
    json.followers  @current_user.followers.count
    json.following  @current_user.followings.count
  else
    json.followers  @user.followers.count
    json.following  @user.followings.count

  end
  json.follow_each_other Follower.where(user_id: @current_user.id,is_following: true, follower_user_id: @user.id,status: 'added').present?
  json.follow_request_send Follower.where(is_following: false, user_id: @user.id,follower_user_id: @current_user.id, status: 'pending').present?  ? true : false
  json.badges_count  @user.badges.count
  json.badges  @user.badges.all.each do |badge|
    json.title badge.title
    json.rarity badge.rarity
    json.badge_image badge.badge_image.attached? ? badge.badge_image.blob.url : ''
  end
  json.all_post_count @user.posts.count
  json.profile_posts @user.posts.each do |post|
    json.post_description post.description
    json.post_time post.created_at
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    json.post_likes post.likes.like.count
    json.post_dislikes post.likes.dislike.count
    json.post_share_count post.share_count
    json.post_type post.post_image.content_type


  end

end
