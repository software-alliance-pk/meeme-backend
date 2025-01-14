json.user_count @users.count
json.user @users.each do|user|
  json.user_id user.id
  json.username user.username
  json.user_active_status user.status
  json.user_image user.profile_image.attached? ? user.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
end