class RenameColumnInBlockUser < ActiveRecord::Migration[7.0]
  def change
    rename_column :block_users, :blocked_by_id, :user_id
  end
end
