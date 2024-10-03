class AddPostIdToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :post_id, :integer
  end
end
