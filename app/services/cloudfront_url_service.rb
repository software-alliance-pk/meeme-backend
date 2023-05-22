class CloudfrontUrlService

  def initialize(image)
    @image = image
  end

  def cloudfront_url
    url = "https://d3mh1peks7kf2k.cloudfront.net/#{@image.blob.key}"
    url
  end

  def generate_thumbnail
    url = "https://d3mh1peks7kf2k.cloudfront.net/#{@image}"
    url
  end
end