json.bgImage @theme.background_image.attached? ? @theme.background_image.blob.url: ""
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
  if @theme.notification_icon_image.attached?
    if @theme.setting_icon_image.attached?
      json.filter @theme.filter_icon_image.blob.url
      json.filter_cross @theme.filter_cross_icon_image.blob.url
      json.setting @theme.setting_icon_image.blob.url
      json.profile_edit @theme.profile_edit_icon_image.blob.url
    end
    json.search @theme.search_icon_image.blob.url
    json.shop @theme.shop_icon_image.blob.url
    json.dots @theme.dots_icon_image.blob.url
    json.like @theme.like_icon_image.blob.url
    json.comment @theme.comment_icon_image.blob.url
    json.share @theme.share_icon_image.blob.url
    json.tournament_forward @theme.tournament_forward_icon_image.blob.url
    json.forward @theme.forward_icon_image.blob.url
    json.pending_requests @theme.pending_requests_icon_image.blob.url
    json.back @theme.main_back_icon_image.blob.url
    json.sms_notification @theme.profile_notification_icon_image.blob.url
    json.edit @theme.edit_icon_image.blob.url
    json.send_support @theme.send_icon_image.blob.url
    json.gallery @theme.gallery_icon_image.blob.url
    json.backward @theme.backward_icon_image.blob.url
    json.notification @theme.notification_icon_image.blob.url
    json.dot_notification @theme.main_notification_icon_image.blob.url
  elsif @theme.filter_icon_image.attached? && @theme.filter_cross_icon_image.attached? && @theme.search_icon_image.attached?
    json.filter @theme.filter_icon_image.blob.url
    json.filter_cross @theme.filter_cross_icon_image.blob.url
    json.search @theme.search_icon_image.blob.url
    if @theme.gallery_icon_image.attached?
      json.gallery @theme.gallery_icon_image.blob.url
    end
  elsif @theme.filter_icon_image.attached? && @theme.filter_cross_icon_image.attached?
    json.filter @theme.filter_icon_image.blob.url
    json.filter_cross @theme.filter_cross_icon_image.blob.url
  elsif @theme.gallery_icon_image.attached? && @theme.search_icon_image.attached?
    json.search @theme.search_icon_image.blob.url
    json.gallery @theme.gallery_icon_image.blob.url
  elsif @theme.gallery_icon_image.attached? && @theme.edit_icon_image.attached?
    json.edit @theme.edit_icon_image.blob.url
    json.gallery @theme.gallery_icon_image.blob.url
  elsif @theme.search_icon_image.attached? || @theme.edit_icon_image.attached?
    if @theme.edit_icon_image.attached?
      json.edit @theme.edit_icon_image.blob.url
    else
      json.search @theme.search_icon_image.blob.url
    end
  end
  # json.nav_bar @theme.tab_bar_image.attached? ? @theme.tab_bar_image.blob.url : ''
end
