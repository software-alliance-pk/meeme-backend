class AddThumbnailInPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts,:thumbnail,:string
  end
end
