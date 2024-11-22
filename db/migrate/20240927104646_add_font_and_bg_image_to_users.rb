class AddFontAndBgImageToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :backgroung_image, :string
    add_column :users, :font, :string
  end
end
