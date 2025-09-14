class AddStatusInLikes < ActiveRecord::Migration[7.0]
  def change
    add_column :likes ,:status,:integer,default: 0
  end
end
