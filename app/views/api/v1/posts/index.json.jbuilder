json.posts do
  json.(@posts) do |post|
    json.id post.id
    json.description post.description
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
  end
end