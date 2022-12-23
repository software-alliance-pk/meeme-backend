class AddStatusInUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users,:push_notifications,:integer,default: 0
  end
end
