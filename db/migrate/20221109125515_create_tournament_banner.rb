class CreateTournamentBanner < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_banners do |t|
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end
  end
end
