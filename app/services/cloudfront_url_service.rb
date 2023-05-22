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

  def admin_urls
    url = "https://d3mh1peks7kf2k.cloudfront.net/#{@image.key}"
    url
  end
end