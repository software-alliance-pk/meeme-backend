class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :user_stores do |t|
      t.integer :user_id, null: true
      t.string :name
      t.bigint :amount
      t.boolean :status, default: false
      t.timestamps
    end
  end
end
