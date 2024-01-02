json.user_stories_count @story_count

# Group stories by user ID
user_stories_map = @story.group_by { |story| story.user_id }

json.user_stories user_stories_map.map do |user_id, user_stories|
  json.stories user_stories.each do |story|
    json.id story.id
    json.user_id user_id
    json.username story.user.username
    json.liked_by_current_user Like.exists?(story_id: story.id, status: 'like', user_id: @current_user.id)
    json.user_image story.user.profile_image.attached? ? story.user.profile_image.blob.url : ''
    json.story_created story.created_at
    json.description story.description
    json.story_image story.story_image.attached? ? story.story_image.blob.url : ''
    json.story_type story.story_image.content_type
    json.story_likes story.likes.count
  end
end