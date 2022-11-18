json.tournament_name @tournament.title
json.tournament_posts_count @tournament.posts.count
json.tournament_posts do
  json.(@tournament.posts) do |post|
    json.username post.user.username
    json.id post.id
    json.description post.description
    json.tag_list post.tag_list
    json.likes post.likes.where(is_liked: true).count
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    json.post_judged_by_current_user post.likes.where(post_id: post.id, user_id: @current_user.id).present?
    json.post_status post.likes.each do |like|
      json.status like.status
    end
  end
end
