class AddFlagMessageToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :flag_message, :string
  end
end
