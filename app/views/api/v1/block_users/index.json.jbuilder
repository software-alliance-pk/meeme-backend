json.blocked_user_details @blocked_users.each do |blocked_user|
  json.id blocked_user.blocked_user.id
  json.username blocked_user.blocked_user.username
  json.profile_image blocked_user.blocked_user.profile_image.attached? ? CloudfrontUrlService.new(blocked_user.blocked_user.profile_image).cloudfront_url : ''
end