class AddLastFourDigitsCards < ActiveRecord::Migration[7.0]
  def change
    add_column :user_cards,:last_four,:integer
  end
end
