json.post do
  json.user_id @post.user.id
  json.username @post.user.username
  json.user_image @post.user.profile_image.attached? ? @post.user.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
  json.post do
    like_by_current_user = @post.likes.find_by(user_id: @current_user.id)
    json.post_id @post.id
    json.post_description @post.description
    json.post_time @post.created_at
    json.post_image @post.post_image.attached? ? @post.post_image.blob.url : ''
    json.tag_list @post.tag_list
    json.post_likes @post.likes.like.count
    json.post_dislikes @post.likes.dislike.count
    json.post_share_count @post.share_count
    json.post_type @post.post_image.content_type
    json.post_share_count @post.share_count
    json.post_thumbnail @post.video_thumbnail.attached? ? @post.video_thumbnail.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : @post.thumbnail
    json.post_comments_count @post.comments.count
    json.liked_by_current_user like_by_current_user.present? ? true : false

    json.compress_image @post.compress_image
  end
  json.post_image @post.post_image.attached? ? @post.post_image.blob.url : ''
  json.post_thumbnail @post.video_thumbnail.attached? ? @post.video_thumbnail.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : @post.thumbnail
  json.post_type @post.post_image.content_type
  json.compress_image @post.post_image.attached? ? @post.post_image.blob.url : ''
  json.liked_by_current_user @post.likes.where(post_id: @post.id, user_id: @current_user.id).present? ? true : false
  json.post_likes @post.likes.count
  json.post_comments_count @post.comments.count
end