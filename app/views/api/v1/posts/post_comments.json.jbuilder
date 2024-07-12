json.post_comments @post_comments.each do |comment|
  json.id comment.id
  json.description comment.description
  json.parent_id comment.parent_id
  json.comment_likes comment.likes.count
  json.child_comments_count comment.comments.count
  json.child_comments comment.comments.each do |child_comment|
    json.id child_comment.id
    json.description child_comment.description
    json.parent_id child_comment.parent_id
    json.child_comment_likes child_comment.likes.count
  end
end