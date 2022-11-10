json.comments do
  json.(@comments) do |comment|
    json.id comment.id
    json.description comment.description
    json.parent_id  comment.parent_id
    json.comment_time  comment.created_at
    json.user comment.user.username
    json.user_image comment.user.profile_image.attached? ? comment.user.profile_image.blob.url : ''
  end
end