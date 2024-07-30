# config/initializers/middleware_debug.rb
Rails.application.config.after_initialize do
    Rails.logger.debug "Middleware stack: #{Rails.application.middleware.inspect}"
  end
  