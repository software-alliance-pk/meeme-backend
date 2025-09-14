class CreateUserCards < ActiveRecord::Migration[7.0]
  def change
    create_table :user_cards do |t|
      t.string :name
      t.string :country
      t.integer :cvc
      t.integer :expiry_month
      t.integer :expiry_year
      t.integer :user_id,null: true

      t.timestamps
    end
  end
end
