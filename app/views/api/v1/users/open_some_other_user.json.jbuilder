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
  # json.follow_each_other @current_user.followers.where(user_id: @user.id, is_following: true ).present?  ? true : false
  json.follow_request_send Follower.where(is_following: false, user_id: @user.id,follower_user_id: @current_user.id, status: 'pending').present?  ? true : false
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
