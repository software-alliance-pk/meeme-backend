class AddIsOpenedToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :is_opened, :boolean
  end
end
