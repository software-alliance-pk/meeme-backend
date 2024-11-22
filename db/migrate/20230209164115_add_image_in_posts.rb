class AddImageInPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts ,:compress_image,:string
  end
end
