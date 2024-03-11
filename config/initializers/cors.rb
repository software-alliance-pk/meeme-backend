Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # Update this with specific domains if needed, e.g., 'example.com'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization'] # Expose any additional headers if required
  end
end
