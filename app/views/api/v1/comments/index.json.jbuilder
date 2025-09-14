json.comments do
  json.(@comments) do |comment|
    json.id comment.id
    json.user_id comment.user.id
    json.description comment.description
    json.parent_id  comment.parent_id
    json.post_comments_count Post.find_by(id: comment.post_id).comments.count
    json.comment_time  comment.created_at
    json.user comment.user.username
    json.user_image comment.user.profile_image.attached? ? comment.user.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
    json.user_comment_like_status comment.likes.where(user_id: @current_user.id).present? ? true : false
    json.comment_image comment.comment_image.attached? ? comment.comment_image.blob.url : ''
    json.comment_like_count comment.likes.count
    json.child_comment comment.comments do |child_comment|
      json.id child_comment.id
      json.user_id child_comment.user.id
      json.description child_comment.description
      json.parent_id  child_comment.parent_id
      json.child_comment_time  child_comment.created_at
      json.user child_comment.user.username
      json.child_comment_like_status child_comment.likes.where(user_id: @current_user.id).present? ? true : false
      json.comment_image child_comment.comment_image.attached? ? child_comment.comment_image.blob.url : ''
      # json.child_comment_like_status child_comment.likes.present? ? true : false
      json.child_comment_like_count child_comment.likes.count
      json.user_image child_comment.user.profile_image.attached? ? child_comment.user.profile_image.blob.variant(resize_to_limit: [512, 512],quality:50).processed.url : ''
    end
  end
end