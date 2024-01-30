class AddSharedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :shared, :integer, default: 0, null: false
  end
end
