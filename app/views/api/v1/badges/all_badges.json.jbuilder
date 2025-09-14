json.badges_count @badges.count
json.badges @badges.each do |badge|
  json.title badge.title
  json.badge_type badge.badge_type
  json.rarity badge.rarity
  json.badge_image badge.badge_image.attached? ? badge.badge_image.blob.url : ''
  json.badges_locked UserBadge.where(user_id: @current_user.id ,badge_id: badge.id).present? ? false: true
end