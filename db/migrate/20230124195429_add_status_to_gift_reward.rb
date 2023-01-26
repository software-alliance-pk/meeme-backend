class AddStatusToGiftReward < ActiveRecord::Migration[7.0]
  def change
    add_column :gift_rewards, :status, :integer, default: 0
  end
end
