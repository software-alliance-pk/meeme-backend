class AddBadgeTypeToBadges < ActiveRecord::Migration[7.0]
  def change
    add_column :badges, :badge_type, :string
  end
end
