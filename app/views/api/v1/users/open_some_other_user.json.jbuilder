json.profile do
  json.user @user
  json.user_image @user.profile_image.attached? ? @user.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
  if @current_user.id==@user.id
    json.followers  @current_user.followers.count
    json.following  @current_user.followings.count
  else
    json.followers  @user.followers.where(user_id: @user.id, status: 'follower_added').count
    json.following  @user.followings.where(follower_user_id: @user.id, status: 'following_added').count

  end
  blocked_user = BlockUser.find_by(blocked_user_id: @user.id, user_id: @current_user.id)
  if blocked_user.present?
    json.blocked_user true
  else
    if Follower.where(user_id: @user.id, follower_user_id: @current_user.id, status: 'follower_added').present? && Follower.where(user_id: @current_user.id, follower_user_id: @user.id, status: 'following_added').present?
      json.follow_each_other true
    elsif Follower.where(user_id: @user.id, follower_user_id: @current_user.id, status: 'follower_added').present?
      json.follower_added true
    elsif Follower.where(user_id: @user.id, follower_user_id: @current_user.id, status: 'pending').present?
      json.follow_request_send true
    end
  end
  json.badges_count  @user.badges.count
  json.badges  @user.badges.all.each do |badge|
    json.title badge.title
    json.badge_type badge.badge_type
    json.rarity badge.rarity
    json.badge_image badge.badge_image.attached? ? badge.badge_image.blob.url : ''
  end
  json.all_post_count @user.posts.count
end
