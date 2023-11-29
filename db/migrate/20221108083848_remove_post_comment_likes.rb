class RemovePostCommentLikes < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :comment_likes
    remove_column :posts, :post_likes
  end
end
