Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://memeredis-ro.osucun.ng.0001.use1.cache.amazonaws.com:6379', size: 12, network_timeout: 5  }
end
Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://memeredis-ro.osucun.ng.0001.use1.cache.amazonaws.com:6379', size: 1, network_timeout: 5  }
end
