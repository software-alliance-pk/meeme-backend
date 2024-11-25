json.recent_posts do
  json.(@recent_posts) do |post|
      json.post post rescue ""
      json.pending_requests @current_user.followers.pending.count
      json.username post.user.username
      json.user_image post.user.profile_image.attached? ? post.user.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
      json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
      json.post_thumbnail post.video_thumbnail.attached? ? post.video_thumbnail.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : post.thumbnail
      json.post_type post.post_image.content_type
      json.compress_image post.post_image.attached? ? post.post_image.blob.url : ''
      json.liked_by_current_user post.likes.where(post_id: post.id, user_id: @current_user.id).present? ? true : false
      json.post_likes post.likes.count
      json.post_comments_count post.comments.count
    end
end
json.coins @current_user.coins