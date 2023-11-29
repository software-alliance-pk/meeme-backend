class CreateCoinPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :coin_prices do |t|
      t.string :coin
      t.decimal :price

      t.timestamps
    end
  end
end
