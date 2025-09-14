json.tutorials @tutorials.each do |tutorial|
  json.description tutorial.description
  json.step tutorial.step
  json.tutorial_images tutorial.tutorial_images.map{|tutorial_image| tutorial_image.present? ? tutorial_image.blob.url : ''}
end