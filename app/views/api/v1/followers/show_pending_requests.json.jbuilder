json.pending_followers_count @user_followers.count
json.pending_followers @user_followers.each do|follower|
  json.id follower.id
  json.user_id follower.user_id
  json.username User.find(follower.user_id).username
  json.user_image User.find(follower.user_id).profile_image.attached? ? User.find(follower.user_id).profile_image.blob.url : ''
  json.is_following follower.is_following?
  json.created_at follower.created_at
  json.updated_at follower.updated_at
  json.follower_user_id follower.follower_user_id
  json.status follower.status
  json.follower_name User.find(follower.follower_user_id).username
  json.follower_image User.find(follower.follower_user_id).profile_image.attached? ? User.find(follower.follower_user_id).profile_image.blob.url : ''

end
