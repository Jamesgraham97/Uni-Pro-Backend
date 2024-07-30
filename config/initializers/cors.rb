# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001' # Replace with your frontend URL if different
    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             expose: ['ETag'], # Expose any headers that your frontend might need
             credentials: true
  end
end
