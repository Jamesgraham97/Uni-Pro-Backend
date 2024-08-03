Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://jamesgraham97.github.io', 'https://unipro.hopto.org' ,'http://localhost:3001'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      max_age: 600,
      expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
  end
end