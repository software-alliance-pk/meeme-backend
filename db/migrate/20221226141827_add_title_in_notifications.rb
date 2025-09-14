class AddTitleInNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications,:title,:string
  end
end
