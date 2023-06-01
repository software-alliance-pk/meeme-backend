json.user_stories_count @story.count
json.user_stories @story.each do |story_user|
  if Story.where(user_id: story_user).recently_created.paginate(page: params[:page], per_page: 25).present?
    json.stories Story.where(user_id: story_user).recently_created.paginate(page: params[:page], per_page: 25).each do |story|
      json.id story.id
      json.user_id story.user_id
      json.username story.user.username
      json.liked_by_current_user Like.where(story_id: story.id, status: 'like', user_id: @current_user.id).present? ? true : false
      json.user_image story.user.profile_image.attached? ? story.user.profile_image.blob.url : ''
      json.story_created story.created_at
      json.description story.description
      json.story_image story.story_image.attached? ? story.story_image.blob.url : ''
      json.story_type story.story_image.content_type
      json.story_likes story.likes.count
    end
  else

  end
end
