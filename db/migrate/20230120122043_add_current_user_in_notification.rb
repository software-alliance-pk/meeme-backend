class AddCurrentUserInNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications ,:sender_id,:integer
    add_column :notifications ,:sender_name,:string
    add_column :notifications ,:sender_image,:string

  end
end
