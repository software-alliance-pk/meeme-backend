class AddBuyPriceInThemes < ActiveRecord::Migration[7.0]
  def change
    add_column :themes, :buy_price, :integer
  end
end
