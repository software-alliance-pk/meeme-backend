class AddAdminUserInMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :admin_user_id, :integer, null: true
    add_column :conversations, :admin_user_id, :integer, null: true
  end
end
