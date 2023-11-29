class CreateDailyCoins < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_coins do |t|
      t.string :daily_coins_reward

      t.timestamps
    end
  end
end