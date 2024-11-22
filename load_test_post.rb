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
  image_url = Faker::LoremFlickr.image(size: "300x300", search_terms: ['user', 'avatar'])
  image_tempfile = Tempfile.new(['image', '.jpg'])
  image_tempfile.binmode
  image_tempfile.write(HTTParty.get(image_url).body)
  image_tempfile.rewind
  image_file = ActionDispatch::Http::UploadedFile.new(
    tempfile: image_tempfile,
    filename: 'image.jpg',
    type: 'image/jpeg'
  )

  payload = {
    description: description,
    user_id: user_id,
    post_image: image_file
  }

  response = HTTParty.post(live, body: payload)
  if response.success?
    puts "Post created successfully!"
  else
    puts "Failed to create post. Response code: #{response.code}"
  end

  image_tempfile.close
  image_tempfile.unlink
end