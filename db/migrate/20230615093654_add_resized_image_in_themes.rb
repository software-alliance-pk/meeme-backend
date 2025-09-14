class AddResizedImageInThemes < ActiveRecord::Migration[7.0]
  def change
    add_column :themes, :resized_image, :string
  end
end
