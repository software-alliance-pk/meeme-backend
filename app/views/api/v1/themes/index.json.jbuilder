json.themes @themes.each do |theme|
  json.name theme.title.split('_').join(' ').titleize
  json.ref theme.title
  # json.font theme.font
  # json.background_colors theme.background_colors
  # json.buttons_color theme.buttons_color
  # json.nav_bar_image theme.nav_bar_image.attached? ? theme.nav_bar_image.blob.url : ''
  json.path theme.tab_bar_image.attached? ? theme.tab_bar_image.url : ''
  # json.width FastImage.size(theme.tab_bar_image.variant(resize: '1800*600^').blob.variant(resize: '1800*600^').url)
  json.coin theme.buy_price
  json.rarity theme.theme_type
  # json.nav_home_icon_image theme.nav_home_icon_image.attached? ? theme.nav_home_icon_image.blob.url : ''
  # json.nav_explore_icon_image theme.nav_explore_icon_image.attached? ? theme.nav_explore_icon_image.blob.url : ''
  # json.nav_tournament_icon_image theme.nav_tournament_icon_image.attached? ? theme.nav_tournament_icon_image.blob.url : ''
  # json.nav_profile_icon_image theme.nav_profile_icon_image.attached? ? theme.nav_profile_icon_image.blob.url : ''
  # json.nav_add_image theme.nav_add_image.attached? ? theme.nav_add_image.blob.url : ''
end