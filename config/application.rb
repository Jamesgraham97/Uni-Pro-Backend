# config/application.rb

require_relative 'boot'
require 'dotenv/load' if %w[development test].include? ENV['RAILS_ENV']

require 'rails/all'
require_relative '../lib/web_socket_server' # Add this line to require the WebSocketServer class

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UniProApplication
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    config.api_only = true

    # Ensure lib directory is autoloaded
    config.eager_load_paths << Rails.root.join('lib')

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::Flash
    config.middleware.use WebSocketServer

    config.session_store :disabled

    config.active_job.queue_adapter = :sidekiq
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://localhost:6379/0' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/0' }
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
