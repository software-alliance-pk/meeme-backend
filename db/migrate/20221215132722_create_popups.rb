class CreatePopups < ActiveRecord::Migration[7.0]
  def change
    create_table :popups do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
