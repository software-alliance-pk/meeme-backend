class RemoveSenderImageFromNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :sender_image, :string
  end
end
