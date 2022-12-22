class AddConversationAndMessageIdToNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :conversation_id, :integer
    add_column :notifications, :message_id, :integer
    add_column :notifications, :follow_request_id, :integer
  end
end
