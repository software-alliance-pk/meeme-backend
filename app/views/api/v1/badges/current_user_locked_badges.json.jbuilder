json.user_badges_count @locked_badges.count
json.user_badges @locked_badges.each do |badge|
  json.title badge.title
  json.rarity badge.rarity
  json.badge_image badge.badge_image.attached? ? badge.badge_image.blob.url : ''
end