class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.text :body
      t.integer :status, default: 0
      t.integer :alert, default: 0
      t.integer :user_id

      t.timestamps
    end
  end
end
