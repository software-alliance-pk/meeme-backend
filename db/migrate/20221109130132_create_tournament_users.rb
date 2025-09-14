class CreateTournamentUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_users do |t|
      t.integer :user_id
      t.integer :tournament_banner_id
      t.timestamps
    end
  end
end
