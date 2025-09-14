class AddUnreadIdToConversations < ActiveRecord::Migration[7.0]
  def change
    add_column :conversations, :unread_id, :integer
  end
end
