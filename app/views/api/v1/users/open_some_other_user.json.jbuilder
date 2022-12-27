json.profile do
  json.user @user
  json.user_image @user.profile_image.attached? ? @user.profile_image.blob.url : ''
  if @current_user.id==@user.id
    json.following  Follower.where(is_following: true,status: 'added',user_id:  @user.id).count
    json.followers  Follower.where(is_following: false, user_id: @user.id,status: 'pending').count + Follower.where(is_following: true,status: 'added',user_id:  @user.id).count

  else
    json.following  Follower.where(is_following: true,status: 'added',follower_user_id:  @user.id).count
    json.followers  Follower.where(is_following: false, follower_user_id: @user.id,status: 'pending').count + Follower.where(is_following: true,status: 'added',follower_user_id:  @user.id).count

  end
  # json.following  Follower.where(is_following: true,status: 'added',follower_user_id:  @user.id).count
  # json.followers  Follower.where(is_following: false, user_id: @user.id,status: 'pending').count + Follower.where(is_following: true,status: 'added',follower_user_id:  @user.id).count
  json.follow_each_other @current_user.followers.where(user_id: @user.id, is_following: true ).present?  ? true : false
  json.follow_request_send Follower.where(is_following: false, user_id: @current_user.id,follower_user_id: @user.id, status: 'pending').present?  ? true : false
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
