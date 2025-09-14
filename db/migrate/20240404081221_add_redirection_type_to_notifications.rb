class AddRedirectionTypeToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :redirection_type, :string
  end
end
