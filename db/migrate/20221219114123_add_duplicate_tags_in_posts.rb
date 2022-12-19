class AddDuplicateTagsInPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts,:duplicate_tags,:string, null: true, array: true
  end
end
