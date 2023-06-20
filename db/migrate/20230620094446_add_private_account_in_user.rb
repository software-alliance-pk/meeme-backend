class AddPrivateAccountInUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :private_account, :boolean, default: false
  end
end
