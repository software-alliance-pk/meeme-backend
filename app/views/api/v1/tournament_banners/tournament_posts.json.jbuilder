json.tournament_name @tournament.title
json.tournament_posts do
  json.(@tournament.posts) do |post|
    json.username post.user.username
    json.id post.id
    json.description post.description
    json.tags post.tags
    json.likes post.likes.count
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
  end
end