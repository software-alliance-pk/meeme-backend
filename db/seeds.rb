# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup). -#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
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


