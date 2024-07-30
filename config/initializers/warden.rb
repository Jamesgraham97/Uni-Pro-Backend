# config/initializers/warden.rb
Warden::JWTAuth.configure do |config|
    config.secret = Rails.application.credentials.devise[:jwt_secret_key]
  end
  