class AddRecipentInMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :receiver_id, :integer, null: true
    add_column :messages, :sender_id, :integer, null: true
    add_column :conversations, :receiver_id, :integer, null: true
    add_column :conversations, :sender_id, :integer, null: true
    remove_column :conversations, :user_1
    remove_column :conversations,:user_2



  end
end
