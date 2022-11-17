class CreateRankingPrice < ActiveRecord::Migration[7.0]
  def change
    create_table :ranking_prices do |t|
      t.text :position,array: true, default: []
      t.integer :tournament_banner_id,null: true
      t.timestamps
    end
  end
end
