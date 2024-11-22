class CreateGiftCardRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_card_requests do |t|
      t.integer :user_id
      t.integer :status
      t.decimal :amount
      t.integer :coins

      t.timestamps
    end
  end
end
