json.child_comments do
  json.(@child_comment) do |child_comment|
    json.id child_comment.id
    json.description child_comment.description
    json.parent_id  child_comment.parent_id
  end
end
