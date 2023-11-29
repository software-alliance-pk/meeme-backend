class AddTournamentBannerIdToLikes < ActiveRecord::Migration[7.0]
  def change
    add_column :likes, :tournament_banner_id, :integer
  end
end
