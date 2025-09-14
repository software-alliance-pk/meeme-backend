class AddCardIdinUserCard < ActiveRecord::Migration[7.0]
  def change
    add_column :user_cards,:card_id, :string
  end
end
