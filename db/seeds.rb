# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup). -#
# # Examples:
# #
# #   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
# #   Character.create(name: "Luke", movie: movies.first)


Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end

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
                


# # Seed data for coin_prices table
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

# # Clear existing records to avoid duplication if needed
# AmazonCard.destroy_all
# # Create 3 static Amazon gift cards
# AmazonCard.create(amount: 10, coin_price: 120000)
# AmazonCard.create(amount: 25, coin_price: 300000)
# AmazonCard.create(amount: 50, coin_price: 600000)
# puts "Amazon gift cards seeded successfully!"
