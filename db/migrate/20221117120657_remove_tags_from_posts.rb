class RemoveTagsFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts,:tags
  end
end
