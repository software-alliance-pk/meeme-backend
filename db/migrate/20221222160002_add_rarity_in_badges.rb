class AddRarityInBadges < ActiveRecord::Migration[7.0]
  def change
    add_column :badges ,:rarity,:integer,default: 0
  end
end
