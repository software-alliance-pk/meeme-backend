  json.child_comments do
  json.(@child_comment) do |child_comment|
    json.id child_comment.id
    json.description child_comment.description
    json.parent_id  child_comment.parent_id
    json.child_comment_time  child_comment.created_at
    json.user child_comment.user.username
    json.user_image child_comment.user.profile_image.attached? ? child_comment.user.profile_image.blob.url : ''
    # json.comment_like_status child_comment.likes.present? ? true : false
    json.child_comment_like_status child_comment.likes.where(user_id: @current_user.id).present? ? true : false
    json.comment_like_count child_comment.likes.count

  end
end
