class CreateThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :themes do |t|
      t.string :title
      t.string :font
      t.string :nav_background_color, array: true, default: []
      t.string :background_colors, array: true, default: []
      t.string :background_colors_percentage, array: true, default: []
      t.string :buttons_color, array: true, default: []
      t.string :buttons_color_percentage, array: true, default: []
      t.string :theme_type

      t.timestamps
    end
  end
end
