class AddJudgedCoinsInTournamentUser < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_users, :total_judged_coins, :integer, default: 0
  end
end
