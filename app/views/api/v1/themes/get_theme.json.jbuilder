json.theme do
  json.title @theme.title
  json.font @theme.font
  json.nav_color @theme.nav_background_color
  json.background_colors @theme.background_colors
  json.buttons_color @theme.buttons_color
  json.nav_bar_image @theme.nav_bar_image.attached? ? @theme.nav_bar_image.blob.url : ''
  json.nav_home_icon_image @theme.nav_home_icon_image.attached? ? @theme.nav_home_icon_image.blob.url : ''
  json.nav_explore_icon_image @theme.nav_explore_icon_image.attached? ? @theme.nav_explore_icon_image.blob.url : ''
  json.nav_tournament_icon_image @theme.nav_tournament_icon_image.attached? ? @theme.nav_tournament_icon_image.blob.url : ''
  json.nav_profile_icon_image @theme.nav_profile_icon_image.attached? ? @theme.nav_profile_icon_image.blob.url : ''
  json.nav_add_image @theme.nav_add_image.attached? ? @theme.nav_add_image.blob.url : ''
  json.nav_bar @theme.tab_bar_image.attached? ? @theme.tab_bar_image.blob.url : ''
end