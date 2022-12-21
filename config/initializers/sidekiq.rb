Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://52.66.198.177:6379/1', size: 12, network_timeout: 5  }
end
Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://52.66.198.177:6379/1', size: 1, network_timeout: 5  }
end
