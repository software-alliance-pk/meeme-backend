json.users do
  json.(@users) do |user|
    json.id user.id
    json.username user.username
    json.user_image user.profile_image.attached? ? rails_blob_url(user.profile_image) : ''
    json.user_posts user.posts.each do |post|
      json.post post
      json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
      json.post_comments post.comments.each do |comment|
        json.id comment.id
        json.description comment.description
        json.parent_id comment.parent_id
        json.child_comments comment.comments.each do |child_comment|
          json.id child_comment.id
          json.description child_comment.description
          json.parent_id child_comment.parent_id
        end
      end
    end
  end
end
