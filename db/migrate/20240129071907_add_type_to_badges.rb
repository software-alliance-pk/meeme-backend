class AddTypeToBadges < ActiveRecord::Migration[7.0]
  def change
    add_column :badges, :type, :string
  end
end
