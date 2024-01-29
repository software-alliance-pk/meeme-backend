class AddExploredToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :explored, :integer, default: 0
  end
end
