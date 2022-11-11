class CreateFollowers < ActiveRecord::Migration[7.0]
  def change
    create_table :followers do |t|
      t.integer :user_id
      t.boolean :is_following , default: false
      t.timestamps
    end
  end
end
