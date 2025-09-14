class CreateGiftRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_rewards do |t|
      t.string :rank
      t.string :card_number
      t.string :amount

      t.timestamps
    end
  end
end
