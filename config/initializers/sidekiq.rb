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
