class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.integer :user_id,null: true
      t.timestamps
    end
  end
end
