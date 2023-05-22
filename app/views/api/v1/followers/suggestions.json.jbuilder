json.suggestions_count @users.count
json.suggestions @users.each do|user|
  json.user user
  json.user_image user.profile_image.attached? ? CloudfrontUrlService.new(user.profile_image).cloudfront_url : ''
end