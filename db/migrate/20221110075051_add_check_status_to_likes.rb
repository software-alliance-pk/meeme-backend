class AddCheckStatusToLikes < ActiveRecord::Migration[7.0]
  def change
    add_column :likes,:is_liked,:boolean,default: false
  end
end
