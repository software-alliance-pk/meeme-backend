json.profile do
  json.user @current_user
  json.user_image @current_user.profile_image.attached? ? @current_user.profile_image.blob.url : ''
  json.followers  @current_user.followers.count
  json.following  @current_user.followings.count
  json.badges_count  @current_user.badges.count
  json.badges  @current_user.badges.all.each do |badge|
    json.title badge.title
    json.rarity badge.rarity
    json.badge_image badge.badge_image.attached? ? badge.badge_image.blob.url : ''
  end
  json.all_post_count @current_user.posts.count
  json.user_post_count @current_user.posts.where(tournament_meme:false).count
  json.profile_posts @current_user.posts.where(tournament_meme: false).each do |post|
    json.post_description post.description
    json.post_time post.created_at
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    json.post_likes post.likes.like.count
    json.post_dislikes post.likes.dislike.count
    json.post_share_count post.share_count
    json.post_type post.post_image.content_type

  end
  json.tournament_posts_count @current_user.posts.where(tournament_meme: true).count
  json.tournament_posts @current_user.posts.where(tournament_meme: true).each do |post|
    json.post_description post.description
    json.post_time post.created_at
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    json.post_likes post.likes.like.count
    json.post_dislikes post.likes.dislike.count
    json.post_share_count post.share_count
    json.post_type post.post_image.content_type


  end

end
