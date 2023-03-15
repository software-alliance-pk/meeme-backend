class AddFlagToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :flagged_by_user, :integer, array: true, default: []
  end
end
