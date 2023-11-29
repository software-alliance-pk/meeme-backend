class AddSubjectInMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :messages,:subject,:integer,default: 0
  end
end
