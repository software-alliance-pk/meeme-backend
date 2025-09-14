class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :description
      t.string :tags
      t.integer :post_likes
      t.integer :user_id
      t.timestamps
    end
  end
end
