class AddEnableInPostsBanner < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :tournament_meme, :boolean, default: false
    add_column  :tournament_banners, :enable,:boolean,default: false
  end
end
