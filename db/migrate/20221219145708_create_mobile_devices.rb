class CreateMobileDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :mobile_devices do |t|
      t.string :mobile_token
      t.integer :user_id

      t.timestamps
    end
  end
end
