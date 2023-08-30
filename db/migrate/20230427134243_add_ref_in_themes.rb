class AddRefInThemes < ActiveRecord::Migration[7.0]
  def change
    add_column :themes, :ref, :string
  end
end
