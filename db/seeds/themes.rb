Theme.destroy_all if Theme.any?
unless Theme.any?
  themes = { 0 => ['silky_black'], 1 => ['space_theme'] ,2 => ['roygbiv_yellow'], 3 => ['brownish'], 4 => ['dark_blue'], 5 => ['blackish'], 6 => ['bluish'],
            7 => ['greenish_yellow'], 8 => ['orangy_yellow'], 9 => ['meteorite'], 10 => ['black'], 11 => ['dusk'], 12 => ["banana"], 13 => ["fire"],
            14 => ['water'], 15 => ['black_sand'], 16 => ['smoky'], 17 => ['pink_poca'], 18 => ['camouflage'], 19 => ['flamingo'], 20 => ['samurai_head'],
            21 => ['phsychedelic'], 22 => ['earth'], 23 => ['earth_tricolor'], 24 => ['clouds'], 25 => ['geometric'], 26 => ['coin']
  }

  # theme_type = %w[default common common common common common common rare rare rare rare rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare
  #                 ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare
  # ]
    theme_type = %w[default ultra_rare common common common common common common common common 
                    common common rare rare rare ultra_rare rare ultra_rare ultra_rare ultra_rare 
                    ultra_rare rare ultra_rare rare ultra_rare ultra_rare rare
    ]


  # ref_title = %w[black space common1 common4 common3 common2 common5 rare1 rare2 rare3 rare4 rare5 ultra_rare1 ultra_rare2 ultra_rare3 ultra_rare4 ultra_rare5 ultra_rare6 ultra_rare7 ultra_rare8
  #               ultra_rare9 ultra_rare10 ultra_rare11 ultra_rare12 ultra_rare13 ultra_rare14 ultra_rare15
  # ]
  ref_title = %w[black space common1 common2 common3 common4 common5 common6 common7 common8 common9 common10 rare1 rare2 rare3 ultra_rare1 
                 rare4 ultra_rare2 ultra_rare3 ultra_rare4 ultra_rare5 rare5 ultra_rare6 rare6 ultra_rare7 ultra_rare8 rare7
  ]


  nav_background_colors = [['#5A1E25'], ['#1B1C25'], ['#0E5241'], ['#FF8C00'], ['#72BD72'], ['#4815AA'], ['#30009B'], ['#9B6675'],
                          ['#3A9EAA'], ['#0C5E73'], ['#0D9265'], ['#4D5E5F'], %w[rgba(245, 91, 57, 1) rgba(129, 89, 42, 0.9)],
                          %w[rgba(125, 63, 62, 1) rgba(55, 55, 55, 0.79)], ['#373737'], ['#373737'], ['#373737']
  ]
  background_colors = [['#310309'], ['#040216'], ['#003528'], ['rgba(255, 140, 0, 0.7)'], ['#72BD72'], ['#4815AA'], ['#30009B'], ['#A18089'], ['#51B7C3'],
                      ['#023341'], ['#13CF8F'], ['#818F90'], %w[rgba(110, 34, 18, 0.95) rgba(20, 17, 35, 1)], %w[rgba(207, 103, 102, 1) rgba(79, 40, 40, 1)],
                      %w[rgba(129, 169, 116, 1) rgba(23, 48, 61, 1)], %w[rgba(167, 202, 200, 1) rgba(23, 48, 61, 1)], %w[rgba(126, 134, 208, 1) rgba(23, 48, 61, 1)]
  ]
  background_colors_percentage = [[''], [''], [''], ['70%'], [''], [''], [''], [''], [''], [''], [''], [''], %w[95% 100%]]
  fonts = ['Product Sans', 'Akshar', 'Alef', 'Quantico', 'Cuprum', 'Readex Pro', 'Sen', 'Yaldevi', 'Saira', 'Pridi', 'Signika', 'Helvetica',
          'Teko', 'Lato', 'Product Sans', 'Product Sans', 'Product Sans'
  ]
  buttons_colors = [%w[#F23F58 #D4233B], ['#FFF62A'], %w[#1EDAAD #00AF85], ['#FF8C00'], ['#569A56'], %w[#FFE299 #F6B202], %w[#FFE299 #F6B202], %w[#FFE299 #F6B202], %w[#FFE299 #F6B202],
                    %w[#FFE299 #F6B202], %w[#FFE299 #F6B202], ['#FFE299'], ['#FFFFFF'], %w[rgba(203, 101, 100, 1) rgba(116, 95, 95, 1)], ['#FFFFFF'], ['#FFFFFF'], ['#FFFFFF']
  ]

  buttons_color_percentage = [%w[100% 100%], [''], %w[100% 100%], [''], [''], %w[100% 100%], %w[100% 100%], %w[100% 100%], %w[100% 100%], %w[100% 100%], %w[100% 100%], [''],
                              ['']
  ]

  prices = {
    'silky_black' => 30000,
    'space_theme' => 150000,
    'roygbiv_yellow' => 30000,
    'brownish' => 10000,
    'dark_blue' => 10000,
    'blackish' => 30000,
    'bluish' => 30000,
    'greenish_yellow' => 30000,
    'orangy_yellow' => 30000,
    'meteorite' => 30000,
    'black' => 30000,
    'dusk' => 30000,
    'banana' => 50000,
    'fire' => 50000,
    'water' => 50000,
    'black_sand' => 100000,
    'smoky' => 50000,
    'pink_poca' => 100000,
    'camouflage' => 100000,
    'flamingo' => 100000,
    'samurai_head' => 100000,
    'phsychedelic' => 50000,
    'earth' => 100000,
    'earth_tricolor' => 50000,
    'clouds' => 100000,
    'geometric' => 100000,
    'coin' => 50000
  }



  IMAGES_PATH = "app/assets/images/meme_themes"
  themes.keys.each do |key|
    themes[key].each do |value|
      images = Dir.glob("#{IMAGES_PATH}/#{value}/theme_pngs/*.png")
      selected_nav_icons = Dir.glob("#{IMAGES_PATH}/#{value}/selected_svgs/*.svg")
      un_selected_nav_icons = Dir.glob("#{IMAGES_PATH}/#{value}/unselected_svgs/*.svg")
      app_svgs = Dir.glob("#{IMAGES_PATH}/#{value}/app_svgs/*.svg")

      images_and_icons = {
        nav_add: images[0],
        tab_bar: images[1],
        background: nil,
        nav_tournament_icon_selected: selected_nav_icons[0],
        nav_explore_icon_selected: selected_nav_icons[1],
        nav_home_icon_selected: selected_nav_icons[2],
        nav_profile_icon_selected: selected_nav_icons[3],
        nav_tournament_icon_unselected: un_selected_nav_icons[0],
        nav_explore_icon_unselected: un_selected_nav_icons[1],
        nav_home_icon_unselected: un_selected_nav_icons[2],
        nav_profile_icon_unselected: un_selected_nav_icons[3],
        filter_icon: nil,
        filter_cross_icon: nil,
        search_icon: nil,
        backward_icon: nil,
        comment_icon: nil,
        dots_icon: nil,
        edit_icon: nil,
        forward_icon: nil,
        gallery_icon: nil,
        like_icon: nil,
        main_back_icon: nil,
        main_notification_icon: nil,
        notification_icon: nil,
        pending_requests_icon: nil,
        profile_edit_icon: nil,
        profile_notification_icon: nil,
        send_icon: nil,
        setting_icon: nil,
        share_icon: nil,
        shop_icon: nil,
        tournament_forward_icon: nil
      }

      if selected_nav_icons.length > 0
        if images.length > 2
          images_and_icons[:background] = images[0]
          images_and_icons[:nav_add] = images[1]
          images_and_icons[:tab_bar] = images[2]
        end
        if app_svgs.length == 0
          images_and_icons.delete(:filter_icon)
          images_and_icons.delete(:filter_cross_icon)
        elsif app_svgs.length == 1
          images_and_icons.delete(:filter_icon)
          images_and_icons.delete(:filter_cross_icon)
          if app_svgs[0] == "#{IMAGES_PATH}/#{value}/app_svgs/search.svg"
            images_and_icons[:search_icon] = app_svgs[0]
          else
            images_and_icons[:edit_icon] = app_svgs[0]
          end
        elsif app_svgs.length == 2
          if app_svgs[0] == "#{IMAGES_PATH}/#{value}/app_svgs/edit.svg" && app_svgs[1] == "#{IMAGES_PATH}/#{value}/app_svgs/gallery.svg"
            images_and_icons[:edit_icon] = app_svgs[0]
            images_and_icons[:gallery_icon] = app_svgs[1]
          elsif app_svgs[0] == "#{IMAGES_PATH}/#{value}/app_svgs/gallery.svg" && app_svgs[1] == "#{IMAGES_PATH}/#{value}/app_svgs/search.svg"
            images_and_icons[:gallery_icon] = app_svgs[0]
            images_and_icons[:search_icon] = app_svgs[1]
          else
            images_and_icons[:filter_icon] = app_svgs[0]
            images_and_icons[:filter_cross_icon] = app_svgs[1]
          end
        elsif app_svgs.length == 3
          images_and_icons[:filter_icon] = app_svgs[0]
          images_and_icons[:filter_cross_icon] = app_svgs[1]
          images_and_icons[:search_icon] = app_svgs[2]
        elsif app_svgs.length == 4
          images_and_icons[:filter_icon] = app_svgs[0]
          images_and_icons[:filter_cross_icon] = app_svgs[1]
          images_and_icons[:gallery_icon] = app_svgs[2]
          images_and_icons[:search_icon] = app_svgs[3]
        elsif app_svgs.length == 18
          images_and_icons[:backward_icon] = app_svgs[0]
          images_and_icons[:comment_icon] = app_svgs[1]
          images_and_icons[:dots_icon] = app_svgs[2]
          images_and_icons[:edit_icon] = app_svgs[3]
          images_and_icons[:filter_icon] = app_svgs[4]
          images_and_icons[:filter_cross_icon] = app_svgs[5]
          images_and_icons[:forward_icon] = app_svgs[6]
          images_and_icons[:gallery_icon] = app_svgs[7]
          images_and_icons[:like_icon] = app_svgs[8]
          images_and_icons[:main_back_icon] = app_svgs[9]
          images_and_icons[:pending_requests_icon] = app_svgs[10]
          images_and_icons[:profile_edit_icon] = app_svgs[11]
          images_and_icons[:profile_notification_icon] = app_svgs[12]
          images_and_icons[:search_icon] = app_svgs[13]
          images_and_icons[:send_icon] = app_svgs[14]
          images_and_icons[:setting_icon] = app_svgs[15]
          images_and_icons[:share_icon] = app_svgs[16]
          images_and_icons[:tournament_forward_icon] = app_svgs[17]
        elsif app_svgs.length == 14
          images_and_icons[:backward_icon] = app_svgs[0]
          images_and_icons[:comment_icon] = app_svgs[1]
          images_and_icons[:dots_icon] = app_svgs[2]
          images_and_icons[:edit_icon] = app_svgs[3]
          images_and_icons[:forward_icon] = app_svgs[4]
          images_and_icons[:gallery_icon] = app_svgs[5]
          images_and_icons[:like_icon] = app_svgs[6]
          images_and_icons[:main_back_icon] = app_svgs[7]
          images_and_icons[:pending_requests_icon] = app_svgs[8]
          images_and_icons[:profile_notification_icon] = app_svgs[9]
          images_and_icons[:search_icon] = app_svgs[10]
          images_and_icons[:send_icon] = app_svgs[11]
          images_and_icons[:share_icon] = app_svgs[12]
          images_and_icons[:tournament_forward_icon] = app_svgs[13]
        end
      else
        images_and_icons[:tab_bar] = images[0]
      end

      theme = Theme.create!(
        title: value,
        theme_type: theme_type[key],
        ref: ref_title[key],
        buy_price: prices[value] || 100 
      )

      images_and_icons.each do |attribute, path|
        next unless path

        attachment_name = "#{value}.png" if attribute.to_s.start_with?("nav", "tab", "background")
        attachment_name = "#{value}.svg" if attribute.to_s.start_with?("nav_tournament", "nav_explore", "nav_home", "nav_profile")
        attachment_name = "#{value}.svg" if attribute.to_s.start_with?("filter", "backward", "comment", "dots","pending_requests","edit", "forward", "gallery", "like", "main_back", "main_notification", "profile_edit", "profile_notification", "send", "setting", "share", "shop", "tournament_forward", "notification")
        attachment_name = "#{value}.svg" if attribute.to_s.start_with?("search")

        theme.send("#{attribute}_image").attach(io: File.open(File.join(Rails.root, path)), filename: attachment_name)
      end
    end
  end
end
puts "Themes seeded successfully!"


# themes = { 0 => ['red_theme'], 1 => ['black_theme'], 2 => ['grenish_theme'], 3 => ['orange_theme'], 4 => ['light_green_theme'],
#            5 => ['blue_theme'], 6 => ['dark_blue_theme'], 7 => ['mauve_taupe_theme'], 8 => ['scooter_theme'], 9 => ['blue_lagoon_theme'],
#            10 => ['elf_green_theme'], 11 => ['river_bed_theme'], 12 => ['hot_curry_theme'], 13 => ['red_robin_theme'], 14 => ['amulet_theme'],
#            15 => ['jungle_mist_theme'], 16 => ['portage_theme'], 17 => ['alice_blue_theme'], 18 => ['chathams_blue_theme'],
#            19 => ['neon_pink_theme'], 20 => ['bittersweet_theme'], 21 => ['sidecar_theme'], 22 => ['light_slate_blue_theme'],
#            23 => ['cornflower_blue_theme'], 24 => ['brandy_rose_theme'], 25 => ['opium_theme'], 26 => ['oasis_theme'], 27 => ['mauve_theme'],
#            28 => ['shalimar_theme'], 29 => ['flamenco_theme'], 30 => ['hawkes_blue_theme'], 31 => ['apple_blossom_theme'], 32 => ['ecstasy_theme'],
#            33 => ['swamp_theme'], 34 => ['sunflower_theme'], 35 => ['pancho_theme'], 36 => ['navy_theme'], 37 => ['patterns_blue_theme'],
#            38 => ['black_russian_theme'], 39 => ['bilbao_theme'], 40 => ['corn_theme'], 41 => ['cherry_pie_theme'], 42 => ['black_rare_theme'],
#            43 => ['chambray_theme']
# }

# theme_type = %w[basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic
#                 basic basic basic basic basic basic basic basic basic basic common common common common common rare rare rare rare rare
# ]
