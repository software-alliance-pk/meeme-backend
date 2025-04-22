require_relative "boot"

require "rails/all"
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MemeeApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.active_storage.variant_processor = :mini_magick
    Rails.application.config.active_storage.service_urls_expire_in = 1.weeks

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.active_job.queue_adapter = :delayed_job
    config.active_job.queue_adapter = :sidekiq

    config.eager_load_paths << Rails.root.join("app/services")
    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.url = "/cable"

    # Add CORS middleware
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*' # Allow requests from any origin
        resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end
        # config.action_controller.default_url_options = { host: 'admin.stg2.memee.app/' }
  end
end
