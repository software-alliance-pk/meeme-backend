# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup). -#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

themes = { 0 => ['red_theme'], 1 => ['black_theme'], 2 => ['grenish_theme'], 3 => ['orange_theme'], 4 => ['light_green_theme'],
           5 => ['blue_theme'], 6 => ['dark_blue_theme'], 7 => ['mauve_taupe_theme'], 8 => ['scooter_theme'], 9 => ['blue_lagoon_theme'],
           10 => ['elf_green_theme'], 11 => ['river_bed_theme'], 12 => ['hot_curry_theme'], 13 => ['red_robin_theme'], 14 => ['amulet_theme'],
           15 => ['jungle_mist_theme'], 16 => ['portage_theme'], 17 => ['alice_blue_theme'], 18 => ['chathams_blue_theme'],
           19 => ['neon_pink_theme'], 20 => ['bittersweet_theme'], 21 => ['sidecar_theme'], 22 => ['light_slate_blue_theme'],
           23 => ['cornflower_blue_theme'], 24 => ['brandy_rose_theme'], 25 => ['opium_theme'], 26 => ['oasis_theme'], 27 => ['mauve_theme'],
           28 => ['shalimar_theme'], 29 => ['flamenco_theme'], 30 => ['hawkes_blue_theme'], 31 => ['apple_blossom_theme'], 32 => ['ecstasy_theme'],
           33 => ['swamp_theme'], 34 => ['sunflower_theme'], 35 => ['pancho_theme'], 36 => ['navy_theme'], 37 => ['patterns_blue_theme'],
           38 => ['black_russian_theme'], 39 => ['bilbao_theme'], 40 => ['corn_theme'], 41 => ['cherry_pie_theme'], 42 => ['black_rare_theme'],
           43 => ['chambray_theme']
}
theme_type = %w[basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic
                basic basic basic basic basic basic basic basic basic basic common common common common common rare rare rare rare rare
]
# nav_background_colors = [['#5A1E25'], ['#1B1C25'], ['#0E5241'], ['#FF8C00'], ['#72BD72'], ['#4815AA'], ['#30009B'], ['#9B6675'],
#                          ['#3A9EAA'], ['#0C5E73'], ['#0D9265'], ['#4D5E5F'], %w[rgba(245, 91, 57, 1) rgba(129, 89, 42, 0.9)],
#                          %w[rgba(125, 63, 62, 1) rgba(55, 55, 55, 0.79)], ['#373737'], ['#373737'], ['#373737']
# ]
# background_colors = [['#310309'], ['#040216'], ['#003528'], ['rgba(255, 140, 0, 0.7)'], ['#72BD72'], ['#4815AA'], ['#30009B'], ['#A18089'], ['#51B7C3'],
#                      ['#023341'], ['#13CF8F'], ['#818F90'], %w[rgba(110, 34, 18, 0.95) rgba(20, 17, 35, 1)], %w[rgba(207, 103, 102, 1) rgba(79, 40, 40, 1)],
#                      %w[rgba(129, 169, 116, 1) rgba(23, 48, 61, 1)], %w[rgba(167, 202, 200, 1) rgba(23, 48, 61, 1)], %w[rgba(126, 134, 208, 1) rgba(23, 48, 61, 1)]
# ]
# background_colors_percentage = [[''], [''], [''], ['70%'], [''], [''], [''], [''], [''], [''], [''], [''], %w[95% 100%]]
# fonts = ['Product Sans', 'Akshar', 'Alef', 'Quantico', 'Cuprum', 'Readex Pro', 'Sen', 'Yaldevi', 'Saira', 'Pridi', 'Signika', 'Helvetica',
#          'Teko', 'Lato', 'Product Sans', 'Product Sans', 'Product Sans'
# ]
# buttons_colors = [%w[#F23F58 #D4233B], ['#FFF62A'], %w[#1EDAAD #00AF85], ['#FF8C00'], ['#569A56'], %w[#FFE299 #F6B202], %w[#FFE299 #F6B202], %w[#FFE299 #F6B202], %w[#FFE299 #F6B202],
#                   %w[#FFE299 #F6B202], %w[#FFE299 #F6B202], ['#FFE299'], ['#FFFFFF'], %w[rgba(203, 101, 100, 1) rgba(116, 95, 95, 1)], ['#FFFFFF'], ['#FFFFFF'], ['#FFFFFF']
# ]

# buttons_color_percentage = [%w[100% 100%], [''], %w[100% 100%], [''], [''], %w[100% 100%], %w[100% 100%], %w[100% 100%], %w[100% 100%], %w[100% 100%], %w[100% 100%], [''],
#                             ['']
# ]
IMAGES_PATH = "app/assets/images/themes"
themes.keys.each do |key|
  themes[key].each do |value|
    images = Dir.glob("#{IMAGES_PATH}/#{value}/*.png")
    icons = Dir.glob("#{IMAGES_PATH}/#{value}/svg/*.svg")
    images_and_icons = {
      nav_bar: images[0],
      nav_add: images[1],
      tab_bar: images[2],
      nav_tournament_icon: icons[0],
      nav_explore_icon: icons[1],
      nav_home_icon: icons[2],
      nav_profile_icon: icons[3]
    }
    theme = Theme.create!(
      title: value,
      # nav_background_color: nav_background_colors[key],
      # background_colors: background_colors[key] ? background_colors[key] : '',
      # background_colors_percentage: background_colors_percentage[key],
      # font: fonts[key],
      # buttons_color: buttons_colors[key],
      theme_type: theme_type[key]
      # buttons_color_percentage: buttons_color_percentage[key]
    )

    images_and_icons.each do |attribute, path|
      attachment_name = "#{value}.png" if attribute.to_s.start_with?("nav", "tab")
      attachment_name = "#{value}.svg" if attribute.to_s.start_with?("nav_tournament", "nav_explore", "nav_home", "nav_profile")
      theme.send("#{attribute}_image").attach(io: File.open(File.join(Rails.root, path)), filename: attachment_name)
    end
    # theme.nav_bar_image.attach(io: File.open(File.join(Rails.root, images[0])), filename: "#{value}.png")
    # theme.nav_add_image.attach(io: File.open(File.join(Rails.root, images[1])), filename: "#{value}.png")
    # theme.tab_bar_image.attach(io: File.open(File.join(Rails.root, images[2])), filename: "#{value}.png")
    # theme.nav_tournament_icon_image.attach(io: File.open(File.join(Rails.root, icons[0])), filename: "#{value}.svg")
    # theme.nav_explore_icon_image.attach(io: File.open(File.join(Rails.root, icons[1])), filename: "#{value}.svg")
    # theme.nav_home_icon_image.attach(io: File.open(File.join(Rails.root, icons[2])), filename: "#{value}.svg")
    # theme.nav_profile_icon_image.attach(io: File.open(File.join(Rails.root, icons[3])), filename: "#{value}.svg")
  end
end

tutorials = { 1 => ["Memee will have a monthly Tournament that users can join."],
              2 => ["The Tournament starts every first day of the month and winners are announced during the last day of each month."],
              3 => ["End Users can join and post  memes in the tournament as many  as they want."],
              4 => ["There are also other ways to accumulate coins. Judging is another way of acquiring coins from the app. End Users can  judge 100 memes daily and gain 50 coins on a daily basis."],
              5 => ["Coins can buy icons, themes, profile and background overlays."],
              6 => ["There are hundreds of combination that you can choose from to make a unique experience using the app."],
              7 => ["The top 3 votes are the tournament winners and will be rewarded with Amazon gift cards."],
              8 => ["The 4th to 10th place in the tournament will receive coin rewards."] }

tutorials.keys.each do |key|
  tutorials[key].each do |value|
    @images = Dir.glob("app/assets/images/tutorials/step#{key}/*.png")
    t = Tutorial.create!(
      description: value,
      step: key,
      images: @images
    )

    t.images.each do |image|
      t.tutorial_images.attach(
        io: File.open(File.join(Rails.root, image)),
        filename: "tutorials.png"
      )
    end
  end
end

badges = { 0 => ["Thousand Miles Badges",
                 "Master Aficionado Badge",
                 "Opinionated Master Badge",
                 "Generous Giver Badge",
                 "Explorer God Badge",
                 "Part Of The Family Badge",
                 "Influencer Badge",
                 "I Love My Community Badge",
                 "Judgment Level 1 Badge",
                 "3rd Place Badge"],
           1 => ["Mega Mileage Badge",
                 "Expert Aficionado Badge",
                 "Reaction Guru Badge",
                 "Better To Give Badge",
                 "Explorer Guru Badge",
                 "Factor Badge",
                 "Well Known Badge",
                 "The Part Of The Part of Crowd Badge",
                 "Spaceship Badge",
                 "Judgment Level 2 Badge",
                 "2nd Place Badge",
                 "Sharing Is Caring Badge"],
           2 => ["Novice Aficionado Badge",
                 "Commentator Badge",
                 "Explorer Badge",
                 "Contributor Badge",
                 "Famous Badge",
                 "Follower Badge",
                 "Judgment Level 3 Badge",
                 "1st Place Badge",
                 "Keepin It A Hundred Badge"] }

badges.keys.each do |keys|
  badges[keys].each do |values|
    v = Badge.create(
      title: values,
      rarity: keys
    )
    v.badge_image.attach(
      io: File.open(File.join(Rails.root, "app/assets/images/badges/#{values}.png")),
      filename: "#{values}.png"
    )
  end
end


