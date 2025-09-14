class AddStoryInLikeComment < ActiveRecord::Migration[7.0]
  def change
    add_column :likes,:story_id,:integer,null: true
    add_column :comments,:story_id,:integer,null: true
  end
end
