class AddSendAllToNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :send_all, :boolean, default: false
    add_column :notifications, :send_date, :string
  end
end
