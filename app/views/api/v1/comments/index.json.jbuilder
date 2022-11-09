json.comments do
  json.(@comments) do |comment|
    json.id comment.id
    json.description comment.description
    json.parent_id  comment.parent_id
  end
end