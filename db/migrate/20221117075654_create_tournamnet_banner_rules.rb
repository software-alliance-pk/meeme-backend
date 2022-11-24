class CreateTournamnetBannerRules < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_banner_rules do |t|
      t.text :rules ,array: true ,default: []
      t.integer :tournament_banner_id, null: true
      t.timestamps
    end
  end
end
