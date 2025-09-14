class AddUserEmailToGiftCardRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :gift_card_requests, :user_email, :string
  end
end
