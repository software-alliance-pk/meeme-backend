class AddIsJudgeToLikes < ActiveRecord::Migration[7.0]
  def change
    add_column :likes,:is_judged, :boolean,default: false
  end
end
