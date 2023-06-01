json.winning_post_count @result.count
if @result.count>1
  json.message "We have a tie"
end
json.winner_posts do
  json.(@result) do |post|
    json.post_likes post.likes.count
    json.username post.user.username
    json.id post.id
    json.description post.description
    json.tag_list post.tag_list
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    json.content_type post.post_image.content_type
    json.compress_image post.compress_image
  end
end