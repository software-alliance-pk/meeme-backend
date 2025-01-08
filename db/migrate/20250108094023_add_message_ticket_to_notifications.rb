class AddMessageTicketToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :message_ticket, :string, null: true
  end
end
