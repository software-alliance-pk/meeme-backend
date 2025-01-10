class AddDeletedByUserToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :deleted_by_user, :boolean, default: false
  end
end
