json.user_badges_count @badges.count
json.user_badges @badges.each do |badge|
  json.title badge.title
  json.badge_image badge.badge_image.attached? ? badge.badge_image.blob.url : ''
end