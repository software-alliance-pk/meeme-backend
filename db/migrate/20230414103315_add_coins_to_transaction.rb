class AddCoinsToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :coins, :string
  end
end
