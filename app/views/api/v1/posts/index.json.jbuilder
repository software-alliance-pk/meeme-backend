json.user_posts do
  json.(@posts) do |post|
    json.id post.id
    json.description post.description
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    json.tag_list post.tag_list
    json.post_type post.post_image.content_type
  end
end