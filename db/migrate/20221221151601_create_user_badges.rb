class CreateUserBadges < ActiveRecord::Migration[7.0]
  def change
    create_table :user_badges do |t|
      t.integer :user_id
      t.integer :badge_id
      t.timestamps
    end
  end
end
