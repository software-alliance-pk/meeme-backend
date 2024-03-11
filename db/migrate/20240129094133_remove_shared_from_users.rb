class RemoveSharedFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :shared, :integer
  end
end
