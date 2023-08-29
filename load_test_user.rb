require 'httparty'
require 'faker'

local = 'http://localhost:3000/api/v1/users'
live = 'http://meme-1648553004.us-east-1.elb.amazonaws.com/api/v1/users'
number_of_users = 110
number_of_users.times do
  username = Faker::Internet.unique.username(specifier: 5..10)
  email = Faker::Internet.unique.email
  password = 'password'
  payload = {
    username: username,
    email: email,
    password: password,
    password_confirmation: password
  }
  response = HTTParty.post(local, body: payload)
  if response.success?
    puts "User #{username} created successfully!"
  else
    puts "Failed to create user #{username}. Response code: #{response.code}"
  end
end