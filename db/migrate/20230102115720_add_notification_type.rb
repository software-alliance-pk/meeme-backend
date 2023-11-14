class AddNotificationType < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :notification_type, :integer,default: 0
  end
end
