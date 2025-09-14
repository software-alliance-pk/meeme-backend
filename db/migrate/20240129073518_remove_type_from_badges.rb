class RemoveTypeFromBadges < ActiveRecord::Migration[7.0]
  def change
    remove_column :badges, :type, :string
  end
end
