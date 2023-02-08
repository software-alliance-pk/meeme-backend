# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup). -#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
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

