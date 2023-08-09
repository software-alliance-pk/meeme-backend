class AddDisableToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :disabled, :boolean, default: false
  end
end