json.following_count @following.count
@following.each do |user|
    json.following_posts user.posts.where(tournament_meme: false).each do |post|
      json.post post
      json.user_id post.user.id
      json.username post.user.username
      json.user_image post.user.profile_image.attached? ? user.profile_image.blob.url : ''
      json.post_count post.user.posts.count
      json.post_share_count post.share_count
      json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
      json.post_type post.post_image.content_type
      json.liked_by_current_user post.likes.where(post_id: post.id, user_id: @current_user.id).present? ? true : false
      json.post_likes post.likes.count
      json.post_comments_count post.comments.count
      json.post_comments post.comments.each do |comment|
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
          # json.grand_child_comments child_comment.comments do |grand_child_comment|
          #   json.id grand_child_comment.id
          #   json.description grand_child_comment.description
          #   json.parent_id grand_child_comment.parent_id
          #   json.child_comment_time grand_child_comment.created_at
          #   json.user grand_child_comment.user.username
          #   json.child_comment_like_status grand_child_comment.likes.where(user_id: @current_user.id).present? ? true : false
          #   json.child_comment_like_count grand_child_comment.likes.count
          #   json.user_image grand_child_comment.user.profile_image.attached? ? grand_child_comment.user.profile_image.blob.url : ''
          # end
        end
      end
    end
  end

