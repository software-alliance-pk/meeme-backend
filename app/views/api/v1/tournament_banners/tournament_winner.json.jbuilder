json.winning_post_count @result.count
json.winner_posts do
  json.(@result) do |post|
    json.post_likes post.likes.count
    json.username post.user.username
    json.id post.id
    json.description post.description
    json.tag_list post.tag_list
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
  end
end