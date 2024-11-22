json.profile do
  json.user @current_user
  json.user_image @current_user.profile_image.attached? ? @current_user.profile_image.blob.url : ''
  json.followers  @current_user.followers.where(user_id: @current_user.id, status: "follower_added").count
  json.following  @current_user.followings.where(follower_user_id: @current_user.id, status: "following_added").count
  json.badges_count  @current_user.badges.count
  json.badges  @current_user.badges.all.each do |badge|
    json.title badge.title
    json.badge_type badge.badge_type
    json.rarity badge.rarity
    json.badge_image badge.badge_image.attached? ? badge.badge_image.blob.url : ''
  end
  json.all_post_count @current_user.posts.count
  json.user_post_count @current_user.posts.where(tournament_meme:false).count
  json.tournament_posts_count @current_user.posts.where(tournament_meme: true).count

end
