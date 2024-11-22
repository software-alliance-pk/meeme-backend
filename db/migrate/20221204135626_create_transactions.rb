class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :charge_id
      t.string :customer_id
      t.integer :amount
      t.string :balance_transaction_id
      t.string :card_number
      t.string :brand
      t.string :currency
      t.integer :user_id,null: true
      t.string :username

      t.timestamps
    end
  end
end
