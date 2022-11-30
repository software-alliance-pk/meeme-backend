json.stories_count @story.count
json.stories do
  json.(@story) do |story|
    json.id story.id
    json.user_id story.user_id
    json.username story.user.username
    json.user_image story.user.profile_image.attached? ? story.user.profile_image.blob.url : ''
    json.story_created story.created_at
    json.story_image story.story_image.attached? ? story.story_image.blob.url : ''
    json.story_likes story.likes.count
  end
end