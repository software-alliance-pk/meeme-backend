class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations do |t|
      t.integer :user_1
      t.integer :user_2

      t.timestamps
    end
  end
end
