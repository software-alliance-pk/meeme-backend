class AddPostCheckTournamentToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts , :is_tournament_post,:boolean, default: :false
  end
end
