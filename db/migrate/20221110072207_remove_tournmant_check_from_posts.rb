class RemoveTournmantCheckFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :is_tournament_post
    add_column :posts,:tournament_banner_id,:integer, null: true
  end
end
