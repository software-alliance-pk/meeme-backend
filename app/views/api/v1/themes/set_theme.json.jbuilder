json.bgImage @theme.background_image.attached? ? CloudfrontUrlService.new(@theme.background_image).cloudfront_url: ""
json.nav_bar do
  # json.title @theme.title
  # json.font @theme.font
  # json.nav_color @theme.nav_background_color
  # json.background_colors @theme.background_colors
  # json.buttons_color @theme.buttons_color
  json.nav_bar_image @theme.nav_bar_image.attached? ? CloudfrontUrlService.new(@theme.nav_bar_image).cloudfront_url : ''
  json.Home @theme.nav_home_icon_unselected_image.attached? ? CloudfrontUrlService.new(@theme.nav_home_icon_unselected_image).cloudfront_url : ''
  json.Explore @theme.nav_explore_icon_unselected_image.attached? ? CloudfrontUrlService.new(@theme.nav_explore_icon_unselected_image).cloudfront_url : ''
  json.Tourment @theme.nav_tournament_icon_unselected_image.attached? ? CloudfrontUrlService.new(@theme.nav_tournament_icon_unselected_image).cloudfront_url : ''
  json.Profile @theme.nav_profile_icon_unselected_image.attached? ? CloudfrontUrlService.new(@theme.nav_profile_icon_unselected_image).cloudfront_url : ''
  json.Memee @theme.nav_add_image.attached? ? CloudfrontUrlService.new(@theme.nav_add_image).cloudfront_url : ''
  json.HomeFill @theme.nav_home_icon_selected_image.attached? ? CloudfrontUrlService.new(@theme.nav_home_icon_selected_image).cloudfront_url : ''
  json.ExploreFill @theme.nav_explore_icon_selected_image.attached? ? CloudfrontUrlService.new(@theme.nav_explore_icon_selected_image).cloudfront_url : ''
  json.TourmentFill @theme.nav_tournament_icon_selected_image.attached? ? CloudfrontUrlService.new(@theme.nav_tournament_icon_selected_image).cloudfront_url : ''
  json.ProfileFill @theme.nav_profile_icon_selected_image.attached? ? CloudfrontUrlService.new(@theme.nav_profile_icon_selected_image).cloudfront_url : ''
  if @theme.notification_icon_image.attached?
    if @theme.setting_icon_image.attached?
      json.filter CloudfrontUrlService.new(@theme.filter_icon_image).cloudfront_url
      json.filter_cross CloudfrontUrlService.new(@theme.filter_cross_icon_image).cloudfront_url
      json.setting CloudfrontUrlService.new(@theme.setting_icon_image).cloudfront_url
      json.profile_edit CloudfrontUrlService.new(@theme.profile_edit_icon_image).cloudfront_url
    end
    json.search CloudfrontUrlService.new(@theme.search_icon_image).cloudfront_url
    json.shop CloudfrontUrlService.new(@theme.shop_icon_image).cloudfront_url
    json.dots CloudfrontUrlService.new(@theme.dots_icon_image).cloudfront_url
    json.like CloudfrontUrlService.new(@theme.like_icon_image).cloudfront_url
    json.comment CloudfrontUrlService.new(@theme.comment_icon_image).cloudfront_url
    json.share CloudfrontUrlService.new(@theme.share_icon_image).cloudfront_url
    json.tournament_forward CloudfrontUrlService.new(@theme.tournament_forward_icon_image).cloudfront_url
    json.forward CloudfrontUrlService.new(@theme.forward_icon_image).cloudfront_url
    json.pending_requests CloudfrontUrlService.new(@theme.pending_requests_icon_image).cloudfront_url
    json.back CloudfrontUrlService.new(@theme.main_back_icon_image).cloudfront_url
    json.sms_notification CloudfrontUrlService.new(@theme.profile_notification_icon_image).cloudfront_url
    json.edit CloudfrontUrlService.new(@theme.edit_icon_image).cloudfront_url
    json.send_support CloudfrontUrlService.new(@theme.send_icon_image).cloudfront_url
    json.gallery CloudfrontUrlService.new(@theme.gallery_icon_image).cloudfront_url
    json.backward CloudfrontUrlService.new(@theme.backward_icon_image).cloudfront_url
    json.notification CloudfrontUrlService.new(@theme.notification_icon_image).cloudfront_url
    json.dot_notification CloudfrontUrlService.new(@theme.main_notification_icon_image).cloudfront_url
  elsif @theme.filter_icon_image.attached? && @theme.filter_cross_icon_image.attached? && @theme.search_icon_image.attached?
    json.filter CloudfrontUrlService.new(@theme.filter_icon_image).cloudfront_url
    json.filter_cross CloudfrontUrlService.new(@theme.filter_cross_icon_image).cloudfront_url
    json.search CloudfrontUrlService.new(@theme.search_icon_image).cloudfront_url
    if @theme.gallery_icon_image.attached?
      json.gallery CloudfrontUrlService.new(@theme.gallery_icon_image).cloudfront_url
    end
  elsif @theme.filter_icon_image.attached? && @theme.filter_cross_icon_image.attached? || @theme.gallery_icon_image.attached?
    if @theme.gallery_icon_image.attached?
      json.search CloudfrontUrlService.new(@theme.search_icon_image).cloudfront_url
      json.gallery CloudfrontUrlService.new(@theme.gallery_icon_image).cloudfront_url
    else
      json.filter CloudfrontUrlService.new(@theme.filter_icon_image).cloudfront_url
      json.filter_cross CloudfrontUrlService.new(@theme.filter_cross_icon_image).cloudfront_url
    end
  elsif @theme.search_icon_image.attached? || @theme.edit_icon_image.attached?
    if @theme.edit_icon_image.attached?
      json.edit CloudfrontUrlService.new(@theme.edit_icon_image).cloudfront_url
    else
      json.search CloudfrontUrlService.new(@theme.search_icon_image).cloudfront_url
    end
  end
  # json.nav_bar @theme.tab_bar_image.attached? ? @theme.tab_bar_image.blob.url : ''
end