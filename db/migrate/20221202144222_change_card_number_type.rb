class ChangeCardNumberType < ActiveRecord::Migration[7.0]
  def change
    change_column :user_cards,:number,:bigint
  end
end
