class AddThemeIdToUserStore < ActiveRecord::Migration[7.0]
  def change
    add_column :user_stores, :theme_id, :integer
  end
end
