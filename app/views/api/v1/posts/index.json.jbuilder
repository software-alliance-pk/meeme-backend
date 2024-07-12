json.user_posts do
  json.(@posts) do |post|
    like_by_current_user = post.likes.find_by(user_id: @user.id)
    json.post_id post.id
    json.post_description post.description
    json.post_time post.created_at
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    json.tag_list post.tag_list
    json.post_likes post.likes.like.count
    json.post_dislikes post.likes.dislike.count
    json.post_share_count post.share_count
    json.post_type post.post_image.content_type
    json.post_share_count post.share_count
    json.post_thumbnail post.thumbnail
    json.post_comments_count post.comments.count
    json.like_by_current_user like_by_current_user.present? ? true : false
    json.compress_image post.compress_image
  end
end