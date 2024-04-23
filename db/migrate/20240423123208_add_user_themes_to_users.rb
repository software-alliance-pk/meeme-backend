class AddUserThemesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_themes, :string
  end
end
