class Addmessageticketinmessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages,:message_ticket,:string,null: true
  end
end
