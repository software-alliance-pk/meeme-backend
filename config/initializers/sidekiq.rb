begin
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'], size: 12, network_timeout: 20,
                     ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_PEER }
    }
    Redis.exists_returns_integer = false
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'], size: 1, network_timeout: 20,
                     ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_PEER }
    }
    Redis.exists_returns_integer = false
  end

rescue Redis::CannotConnectError => e
  puts "Error connecting to Redis: #{e.message}"
  # Log the error
  Rails.logger.error "Error connecting to Redis: #{e.message}"

  # Retry connecting to Redis after a delay
  sleep 5
  retry
rescue => e
  puts "Unexpected error: #{e.message}"
  # Handle other unexpected errors
  Rails.logger.error "Unexpected error: #{e.message}"
    
  exit 1
end
