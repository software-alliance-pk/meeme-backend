class AddNameInAdminUser < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users,:full_name,:string,null: true
    add_column :admin_users,:admin_user_name,:string,null: true
  end
end
