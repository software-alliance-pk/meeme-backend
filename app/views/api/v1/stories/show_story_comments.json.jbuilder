json.story_comment do
  json.(@story_comment) do |story_comment|
    json.id story_comment.id
    json.story_comment_description story_comment.description
    json.user_commented story_comment.user.username
  end
end