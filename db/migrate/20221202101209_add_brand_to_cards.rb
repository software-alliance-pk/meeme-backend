class AddBrandToCards < ActiveRecord::Migration[7.0]
  def change
    add_column :user_cards,:brand,:string
  end
end
