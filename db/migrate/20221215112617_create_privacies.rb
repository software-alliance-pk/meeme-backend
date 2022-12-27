class CreatePrivacies < ActiveRecord::Migration[7.0]
  def change
    create_table :privacies do |t|
      t.string :description

      t.timestamps
    end
  end
end
