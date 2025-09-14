if @user_followers.present?
  json.followers_count @user_followers.count
  json.followers @user_followers.each do |follower|
    json.id follower.id
    json.user_id follower.user_id
    json.is_following follower.is_following
    json.follower_user_id follower.follower_user_id
    json.status follower.status
    follower_user = User.find_by(id: follower.follower_user_id)
    if follower_user.present?
      json.follower_user_detail do
        json.id follower_user.id
        json.username follower_user.username
        json.email follower_user.email
        json.profile_image follower_user.profile_image.attached? ? follower_user.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
      end
    end
  end
elsif @user_followings.present?
  json.following_count @user_followings.count
  json.followings @user_followings.each do |following|
    json.id following.id
    json.user_id following.user_id
    json.is_following following.is_following
    json.follower_user_id following.follower_user_id
    json.status following.status
    following_user = User.find_by(id: following.user_id)
    if following_user.present?
      json.following_user_detail do
        json.id following_user.id
        json.username following_user.username
        json.email following_user.email
        json.profile_image following_user.profile_image.attached? ? following_user.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
      end
    end
  end
end