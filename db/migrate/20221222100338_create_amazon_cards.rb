class CreateAmazonCards < ActiveRecord::Migration[7.0]
  def change
    create_table :amazon_cards do |t|
      t.string :amount
      t.string :gift_card_number
      t.integer :coin_price

      t.timestamps
    end
  end
end
