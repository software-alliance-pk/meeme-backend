if @posts.present?
  json.tag params[:tag]
  json.post_count @posts.count
  json.explore_posts do
    json.(@posts) do |post|
      json.user_id post.user.id
      json.username post.user.username
      json.user_image post.user.profile_image.attached? ? post.user.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
      json.post post
      json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
      json.post_thumbnail post.video_thumbnail.attached? ? post.video_thumbnail.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : post.thumbnail
      json.compress_image post.post_image.attached? && post.post_image&.image? ? post.post_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
      json.post_type post.post_image.content_type
      json.liked_by_current_user post.likes.where(post_id: post.id, user_id: @current_user.id).present? ? true : false
      json.post_likes post.likes.count
      json.post_comments_count post.comments.count
    end
  end
else
  json.explore_posts []
  if @users.present?
    json.user_count @users.count
    json.user @users.each do |user|
      json.user_id user.id
      json.username user.username
      json.user_image user.profile_image.attached? ? user.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
    end
  end
end
