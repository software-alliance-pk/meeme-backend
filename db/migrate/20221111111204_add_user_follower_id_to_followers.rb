class AddUserFollowerIdToFollowers < ActiveRecord::Migration[7.0]
  def change
    add_column :followers, :follower_user_id ,:integer,null: true
  end
end
