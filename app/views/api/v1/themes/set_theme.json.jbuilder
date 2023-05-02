json.nav_bar do
  # json.title @theme.title
  # json.font @theme.font
  # json.nav_color @theme.nav_background_color
  # json.background_colors @theme.background_colors
  # json.buttons_color @theme.buttons_color
  json.nav_bar_image @theme.nav_bar_image.attached? ? @theme.nav_bar_image.blob.url : ''
  json.Home @theme.nav_home_icon_unselected_image.attached? ? @theme.nav_home_icon_unselected_image.blob.url : ''
  json.Explore @theme.nav_explore_icon_unselected_image.attached? ? @theme.nav_explore_icon_unselected_image.blob.url : ''
  json.Tourment @theme.nav_tournament_icon_unselected_image.attached? ? @theme.nav_tournament_icon_unselected_image.blob.url : ''
  json.Profile @theme.nav_profile_icon_unselected_image.attached? ? @theme.nav_profile_icon_unselected_image.blob.url : ''
  json.Memee @theme.nav_add_image.attached? ? @theme.nav_add_image.blob.url : ''
  json.HomeFill @theme.nav_home_icon_selected_image.attached? ? @theme.nav_home_icon_selected_image.blob.url : ''
  json.ExploreFill @theme.nav_explore_icon_selected_image.attached? ? @theme.nav_explore_icon_selected_image.blob.url : ''
  json.TourmentFill @theme.nav_tournament_icon_selected_image.attached? ? @theme.nav_tournament_icon_selected_image.blob.url : ''
  json.ProfileFill @theme.nav_profile_icon_selected_image.attached? ? @theme.nav_profile_icon_selected_image.blob.url : ''
  if @theme.filter_icon_image.attached? && @theme.filter_cross_icon_image.attached?
    json.filter @theme.filter_icon_image.blob.url
    json.filter_cross @theme.filter_cross_icon_image.blob.url
  elsif @theme.search_icon_image.attached?
    json.search @theme.search_icon_image.blob.url
  end
  # json.nav_bar @theme.tab_bar_image.attached? ? @theme.tab_bar_image.blob.url : ''
end