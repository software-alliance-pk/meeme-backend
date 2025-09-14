namespace :db do
    namespace :seed do
      desc 'Seed data specifically for coin_prices'
      task coin_prices: :environment do
        load File.join(Rails.root, 'db', 'seeds.rb')
      end
    end
  end
  