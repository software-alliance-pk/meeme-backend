require 'httparty'
require 'faker'
require 'tempfile'
require 'action_dispatch/http/upload'

local = 'http://localhost:3000/api/v1/posts'
live = 'http://meme-1648553004.us-east-1.elb.amazonaws.com/api/v1/posts'
number_of_posts = 1000

number_of_posts.times do
  description = Faker::Lorem.paragraph(sentence_count: 4)
  user_id = 1

  video_path = '/home/fahad-ror/Downloads/pexels-pixabay-856787-1920x1080-30fps.mp4'
  video_file = ActionDispatch::Http::UploadedFile.new(
    tempfile: File.new(video_path),
    filename: 'video.mp4',
    type: 'video/mp4'
  )

  payload = {
    description: description,
    user_id: user_id,
    post_image: video_file
  }

  response = HTTParty.post(live, body: payload)
  if response.success?
    puts "Post created successfully!"
  else
    puts "Failed to create Post. Response code: #{response.code}"
  end
end