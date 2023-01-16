class AddDescriptionInStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :description,:string
  end
end
