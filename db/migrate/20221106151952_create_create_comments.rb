class CreateCreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :description
      t.integer :comment_likes
      t.integer :post_id
      t.timestamps
    end
  end
end
