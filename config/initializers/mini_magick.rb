# MiniMagick.configure do |config|
#     config.cli = :imagemagick
#   end

MiniMagick.configure do |config|
  config.cli = :graphicsmagick #:imagemagick  or :imagemagick7
end