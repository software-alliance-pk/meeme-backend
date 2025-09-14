class CreateTutorials < ActiveRecord::Migration[7.0]
  def change
    create_table :tutorials do |t|
      t.integer :step, default: 0
      t.string :description
      t.string :images, array: true, default: []

      t.timestamps
    end
  end
end
