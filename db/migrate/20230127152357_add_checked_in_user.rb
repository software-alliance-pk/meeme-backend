class AddCheckedInUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :checked, :boolean, default: false
  end
end
