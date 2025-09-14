class AddNumberInUserCard < ActiveRecord::Migration[7.0]
  def change
    add_column :user_cards,:number,:integer,default: 0
  end
end
