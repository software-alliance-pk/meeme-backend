# config/initializers/redis.rb

$redis = Redis.new(url: ENV['REDIS_URL'])

# Handle Redis connection errors
def handle_redis_connection
  yield
rescue Redis::BaseConnectionError => e
  Rails.logger.error "Redis connection error: #{e.message}"
  sleep 100
  retry
end
