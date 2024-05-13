# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup). -#
# # Examples:
# #
# #   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
# #   Character.create(name: "Luke", movie: movies.first)

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


# themes = { 0 => ['silky_black'], 1 => ['space_theme'] ,2 => ['roygbiv_yellow'], 3 => ['brownish'], 4 => ['dark_blue'], 5 => ['blackish'], 6 => ['bluish'],
#            7 => ['greenish_yellow'], 8 => ['orangy_yellow'], 9 => ['meteorite'], 10 => ['black'], 11 => ['dusk'], 12 => ["banana"], 13 => ["fire"],
#            14 => ['water'], 15 => ['blacksand'], 16 => ['smoky'], 17 => ['pink_polka'], 18 => ['camouflage'], 19 => ['flamingo'], 20 => ['samurai_head'],
#            21 => ['phsychedelic'], 22 => ['earth'], 23 => ['tricolor'], 24 => ['clouds'], 25 => ['geometric'], 26 => ['coin']
# }

# # themes = { 0 => ['silky_black'], 1 => ['space_theme'] ,2 => ['roygbiv_yellow'], 3 => ['brownish'], 4 => ['dark_blue'], 5 => ['blackish'] }
# theme_type = %w[default common common common common common common rare rare rare rare rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare
#                 ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare ultra_rare
# ]
# ref_title = %w[black space common1 common4 common3 common2 common5 rare1 rare2 rare3 rare4 rare5 ultra_rare1 ultra_rare2 ultra_rare3 ultra_rare4 ultra_rare5 ultra_rare6 ultra_rare7 ultra_rare8
#                ultra_rare9 ultra_rare10 ultra_rare11 ultra_rare12 ultra_rare13 ultra_rare14 ultra_rare15
# ]
# theme_type = %w[basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic basic
#                 basic basic basic basic basic basic basic basic basic basic common common common common common rare rare rare rare rare
# ]
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

# prices = {
#   'silky_black' => 150,
#   'space_theme' => 200,
#   'roygbiv_yellow' => 250,
#   'brownish' => 300,
#   'dark_blue' => 350,
#   'blackish' => 400,
#   'bluish' => 450,
#   'greenish_yellow' => 500,
#   'orangy_yellow' => 550,
#   'meteorite' => 600,
#   'black' => 650,
#   'dusk' => 700,
#   'banana' => 750,
#   'fire' => 800,
#   'water' => 850,
#   'blacksand' => 900,
#   'smoky' => 950,
#   'pink_polka' => 1000,
#   'camouflage' => 1050,
#   'flamingo' => 1100,
#   'samurai_head' => 1150,
#   'phsychedelic' => 1200,
#   'earth' => 1250,
#   'tricolor' => 1300,
#   'clouds' => 1350,
#   'geometric' => 1400,
#   'coin' => 1450
# }

# IMAGES_PATH = "app/assets/images/meme_themes"
# themes.keys.each do |key|
#   themes[key].each do |value|
#     images = Dir.glob("#{IMAGES_PATH}/#{value}/theme_pngs/*.png")
#     selected_nav_icons = Dir.glob("#{IMAGES_PATH}/#{value}/selected_svgs/*.svg")
#     un_selected_nav_icons = Dir.glob("#{IMAGES_PATH}/#{value}/unselected_svgs/*.svg")
#     app_svgs = Dir.glob("#{IMAGES_PATH}/#{value}/app_svgs/*.svg")

#     images_and_icons = {
#       nav_add: images[0],
#       tab_bar: images[1],
#       background: nil,
#       nav_tournament_icon_selected: selected_nav_icons[0],
#       nav_explore_icon_selected: selected_nav_icons[1],
#       nav_home_icon_selected: selected_nav_icons[2],
#       nav_profile_icon_selected: selected_nav_icons[3],
#       nav_tournament_icon_unselected: un_selected_nav_icons[0],
#       nav_explore_icon_unselected: un_selected_nav_icons[1],
#       nav_home_icon_unselected: un_selected_nav_icons[2],
#       nav_profile_icon_unselected: un_selected_nav_icons[3],
#       filter_icon: nil,
#       filter_cross_icon: nil,
#       search_icon: nil,
#       backward_icon: nil,
#       comment_icon: nil,
#       dots_icon: nil,
#       edit_icon: nil,
#       forward_icon: nil,
#       gallery_icon: nil,
#       like_icon: nil,
#       main_back_icon: nil,
#       main_notification_icon: nil,
#       notification_icon: nil,
#       pending_requests_icon: nil,
#       profile_edit_icon: nil,
#       profile_notification_icon: nil,
#       send_icon: nil,
#       setting_icon: nil,
#       share_icon: nil,
#       shop_icon: nil,
#       tournament_forward_icon: nil
#     }

#     if selected_nav_icons.length > 0
#       if images.length > 2
#         images_and_icons[:background] = images[0]
#         images_and_icons[:nav_add] = images[1]
#         images_and_icons[:tab_bar] = images[2]
#       end
#       if app_svgs.length == 0
#         images_and_icons.delete(:filter_icon)
#         images_and_icons.delete(:filter_cross_icon)
#       elsif app_svgs.length == 1
#         images_and_icons.delete(:filter_icon)
#         images_and_icons.delete(:filter_cross_icon)
#         if app_svgs[0] == "#{IMAGES_PATH}/#{value}/app_svgs/search.svg"
#           images_and_icons[:search_icon] = app_svgs[0]
#         else
#           images_and_icons[:edit_icon] = app_svgs[0]
#         end
#       elsif app_svgs.length == 2
#         if app_svgs[0] == "#{IMAGES_PATH}/#{value}/app_svgs/edit.svg" && app_svgs[1] == "#{IMAGES_PATH}/#{value}/app_svgs/gallery.svg"
#           images_and_icons[:edit_icon] = app_svgs[0]
#           images_and_icons[:gallery_icon] = app_svgs[1]
#         elsif app_svgs[0] == "#{IMAGES_PATH}/#{value}/app_svgs/gallery.svg" && app_svgs[1] == "#{IMAGES_PATH}/#{value}/app_svgs/search.svg"
#           images_and_icons[:gallery_icon] = app_svgs[0]
#           images_and_icons[:search_icon] = app_svgs[1]
#         else
#           images_and_icons[:filter_icon] = app_svgs[0]
#           images_and_icons[:filter_cross_icon] = app_svgs[1]
#         end
#       elsif app_svgs.length == 3
#         images_and_icons[:filter_icon] = app_svgs[0]
#         images_and_icons[:filter_cross_icon] = app_svgs[1]
#         images_and_icons[:search_icon] = app_svgs[2]
#       elsif app_svgs.length == 4
#         images_and_icons[:filter_icon] = app_svgs[0]
#         images_and_icons[:filter_cross_icon] = app_svgs[1]
#         images_and_icons[:gallery_icon] = app_svgs[2]
#         images_and_icons[:search_icon] = app_svgs[3]
#       elsif app_svgs.length == 21
#         images_and_icons[:backward_icon] = app_svgs[0]
#         images_and_icons[:comment_icon] = app_svgs[1]
#         images_and_icons[:dots_icon] = app_svgs[2]
#         images_and_icons[:edit_icon] = app_svgs[3]
#         images_and_icons[:filter_icon] = app_svgs[4]
#         images_and_icons[:filter_cross_icon] = app_svgs[5]
#         images_and_icons[:forward_icon] = app_svgs[6]
#         images_and_icons[:gallery_icon] = app_svgs[7]
#         images_and_icons[:like_icon] = app_svgs[8]
#         images_and_icons[:main_back_icon] = app_svgs[9]
#         images_and_icons[:main_notification_icon] = app_svgs[10]
#         images_and_icons[:notification_icon] = app_svgs[11]
#         images_and_icons[:pending_requests_icon] = app_svgs[12]
#         images_and_icons[:profile_edit_icon] = app_svgs[13]
#         images_and_icons[:profile_notification_icon] = app_svgs[14]
#         images_and_icons[:search_icon] = app_svgs[15]
#         images_and_icons[:send_icon] = app_svgs[16]
#         images_and_icons[:setting_icon] = app_svgs[17]
#         images_and_icons[:share_icon] = app_svgs[18]
#         images_and_icons[:shop_icon] = app_svgs[19]
#         images_and_icons[:tournament_forward_icon] = app_svgs[20]
#       elsif app_svgs.length == 17
#         images_and_icons[:backward_icon] = app_svgs[0]
#         images_and_icons[:comment_icon] = app_svgs[1]
#         images_and_icons[:dots_icon] = app_svgs[2]
#         images_and_icons[:edit_icon] = app_svgs[3]
#         images_and_icons[:forward_icon] = app_svgs[4]
#         images_and_icons[:gallery_icon] = app_svgs[5]
#         images_and_icons[:like_icon] = app_svgs[6]
#         images_and_icons[:main_back_icon] = app_svgs[7]
#         images_and_icons[:main_notification_icon] = app_svgs[8]
#         images_and_icons[:notification_icon] = app_svgs[9]
#         images_and_icons[:pending_requests_icon] = app_svgs[10]
#         images_and_icons[:profile_notification_icon] = app_svgs[11]
#         images_and_icons[:search_icon] = app_svgs[12]
#         images_and_icons[:send_icon] = app_svgs[13]
#         images_and_icons[:share_icon] = app_svgs[14]
#         images_and_icons[:shop_icon] = app_svgs[15]
#         images_and_icons[:tournament_forward_icon] = app_svgs[16]
#       end
#     else
#       images_and_icons[:tab_bar] = images[0]
#     end

#     theme = Theme.create!(
#       title: value,
#       theme_type: theme_type[key],
#       ref: ref_title[key],
#       buy_price: prices[value] || 100 
#     )

#     images_and_icons.each do |attribute, path|
#       next unless path

#       attachment_name = "#{value}.png" if attribute.to_s.start_with?("nav", "tab", "background")
#       attachment_name = "#{value}.svg" if attribute.to_s.start_with?("nav_tournament", "nav_explore", "nav_home", "nav_profile")
#       attachment_name = "#{value}.svg" if attribute.to_s.start_with?("filter", "backward", "comment", "dots","pending_requests","edit", "forward", "gallery", "like", "main_back", "main_notification", "profile_edit", "profile_notification", "send", "setting", "share", "shop", "tournament_forward", "notification")
#       attachment_name = "#{value}.svg" if attribute.to_s.start_with?("search")

#       theme.send("#{attribute}_image").attach(io: File.open(File.join(Rails.root, path)), filename: attachment_name)
#     end
#   end
# end

# tutorials = { 1 => ["Memee will have a monthly Tournament that users can join."],
#               2 => ["The Tournament starts every first day of the month and winners are announced during the last day of each month."],
#               3 => ["End Users can join and post  memes in the tournament as many  as they want."],
#               4 => ["There are also other ways to accumulate coins. Judging is another way of acquiring coins from the app. End Users can  judge 100 memes daily and gain 50 coins on a daily basis."],
#               5 => ["Coins can buy icons, themes, profile and background overlays."],
#               6 => ["There are hundreds of combination that you can choose from to make a unique experience using the app."],
#               7 => ["The top 3 votes are the tournament winners and will be rewarded with Amazon gift cards."],
#               8 => ["The 4th to 10th place in the tournament will receive coin rewards."] }

# tutorials.keys.each do |key|
#   tutorials[key].each do |value|
#     @images = Dir.glob("app/assets/images/tutorials/step#{key}/*.png")
#     t = Tutorial.create!(
#       description: value,
#       step: key,
#       images: @images
#     )

#     t.images.each do |image|
#       t.tutorial_images.attach(
#         io: File.open(File.join(Rails.root, image)),
#         filename: "tutorials.png"
#       )
#     end
#   end
# end

# Old Badges 

# badges = { 0 => ["Thousand Miles Badges",
#                  "Master Aficionado Badge",
#                  "Opinionated Master Badge",
#                  "Generous Giver Badge",
#                  "Explorer God Badge",
#                  "Part Of The Family Badge",
#                  "Influencer Badge",
#                  "I Love My Community Badge",
#                  "Judgment Level 1 Badge",
#                  "3rd Place Badge"],
#            1 => ["Mega Mileage Badge",
#                  "Expert Aficionado Badge",
#                  "Reaction Guru Badge",
#                  "Better To Give Badge",
#                  "Explorer Guru Badge",
#                  "Factor Badge",
#                  "Well Known Badge",
#                  "The Part Of The Part of Crowd Badge",
#                  "Spaceship Badge",
#                  "Judgment Level 2 Badge",
#                  "2nd Place Badge",
#                  "Sharing Is Caring Badge"],
#            2 => ["Novice Aficionado Badge",
#                  "Commentator Badge",
#                  "Explorer Badge",
#                  "Contributor Badge",
#                  "Famous Badge",
#                  "Follower Badge",
#                  "Judgment Level 3 Badge",
#                  "1st Place Badge",
#                  "Keepin It A Hundred Badge"] }

# badges.keys.each do |keys|
#   badges[keys].each do |values|
#     v = Badge.create(
#       title: values,
#       rarity: keys
#     )
#     v.badge_image.attach(
#       io: File.open(File.join(Rails.root, "app/assets/images/badges/#{values}.png")),
#       filename: "#{values}.png"
#     )
#   end
# end


# New Badges Mar-2024

# badges = { 0 => ["Commentator Bronze",
#                  "Commentator Gold",
#                  "Commentator Silver",
#                  "Explore Guru Bronze",
#                  "Explore Guru Gold",
#                  "Explore Guru Silver",
#                  "Follower Bronze",
#                  "Follower Gold",
#                  "Follower Silver",
#                  "Gain Followers Bronze"],
#            1 => ["Gain Followers Gold",
#                  "Gain Followers Silver",
#                  "Judge Bronze",
#                  "Judge Gold",
#                  "Judge Silver",
#                  "Likeable Bronze",
#                  "Likeable Gold",
#                  "Likeable Silver",
#                  "Memes Gold",
#                  "Memes Silver",
#                  "Sharer Bronze",
#                  "Sharer Gold"],
#            2 => ["Sharer Silver",
#                  "Upload Photo Bronze",
#                  "Upload Photo Gold",
#                  "Upload Photo Silver"] }

#                  badge_limits = { 
#                   "Commentator Bronze" => { limit: 100, type: "commentator_badge" },
#                   "Commentator Gold" => { limit: 1000000, type: "commentator_badge" },
#                   "Commentator Silver" => { limit: 500000, type: "commentator_badge" },
#                   "Explore Guru Bronze" => { limit: 1000, type: "explore_guru_badge" },
#                   "Explore Guru Gold" => { limit: 10000, type: "explore_guru_badge" },
#                   "Explore Guru Silver" => { limit: 5000000, type: "explore_guru_badge" },
#                   "Follower Bronze" => { limit: 100, type: "follower_badge" },
#                   "Follower Gold" => { limit: 100000, type: "follower_badge" },
#                   "Follower Silver" => { limit: 5000, type: "follower_badge" },
#                   "Gain Followers Bronze" => { limit: 100, type: "gain_followers_badge" },
#                   "Gain Followers Gold" => { limit: 100000, type: "gain_followers_badge" },
#                   "Gain Followers Silver" => { limit: 5000, type: "gain_followers_badge" },
#                   "Judge Bronze" => { limit: 7, type: "judge_badge" },
#                   "Judge Gold" => { limit: 60, type: "judge_badge" },
#                   "Judge Silver" => { limit: 30, type: "judge_badge" },
#                   "Likeable Bronze" => { limit: 1000, type: "likeable_badge" },
#                   "Likeable Gold" => { limit: 1000000, type: "likeable_badge" },
#                   "Likeable Silver" => { limit: 50000, type: "likeable_badge" },
#                   "Memes Gold" => { limit: 10000, type: "memes_badge" },
#                   "Memes Silver" => { limit: 1000, type: "memes_badge" },
#                   "Sharer Bronze" => { limit: 100, type: "sharer_badge" },
#                   "Sharer Gold" => { limit: 1000000, type: "sharer_badge" },
#                   "Sharer Silver" => { limit: 500000, type: "sharer_badge" },
#                   "Upload Photo Bronze" => { limit: 100, type: "upload_photo_badge" },
#                   "Upload Photo Gold" => { limit: 1000000, type: "upload_photo_badge" },
#                   "Upload Photo Silver" => { limit: 500000, type: "upload_photo_badge" }
#                 }

#                 badges.keys.each do |rarity|
#                   badges[rarity].each do |title|
#                     attributes = badge_limits[title] || { limit: 0, type: "badge" }
#                     v = Badge.create(
#                       title: title,
#                       rarity: rarity,
#                       limit: attributes[:limit],
#                       badge_type: attributes[:type]
#                     )
#                     v.badge_image.attach(
#                       io: File.open(File.join(Rails.root, "app/assets/images/NewBadges/#{title}.png")),
#                       filename: "#{title}.png"
#                     )
#                   end
#                 end
                


# Seed data for coin_prices table
# coin_prices_data = [
#   { coin: '10000', price: 1 },
#   { coin: '30000', price: 3 },
#   { coin: '50000', price: 5 },
#   { coin: '100000', price: 10 },
# ]

# # Create seed data for coin_prices
# coin_prices_data.each do |data|
#   CoinPrice.create!(coin: data[:coin], price: data[:price])
# end

# Clear existing records to avoid duplication if needed
AmazonCard.destroy_all
# Create 3 static Amazon gift cards
AmazonCard.create(amount: 10, coin_price: 120000)
AmazonCard.create(amount: 25, coin_price: 300000)
AmazonCard.create(amount: 50, coin_price: 600000)
puts "Amazon gift cards seeded successfully!"
