json.stories_count @story.count
json.stories do
  json.(@story) do |story|
    json.id story.id
    json.story_image story.story_image.attached? ? story.story_image.blob.url : ''
    json.story_likes story.likes.count
  end
end