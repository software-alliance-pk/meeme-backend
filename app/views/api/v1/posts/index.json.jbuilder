json.user_posts do
  json.(@posts) do |post|
    json.id post.id
    json.description post.description
    json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
    json.tag_list post.tag_list
    json.post_type post.post_image.content_type
    json.post_share_count post.share_count
    json.post_thumbnail post.thumbnail
    json.compress_image post.compress_image

  end
end