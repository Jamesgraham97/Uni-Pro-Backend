# spec/rails_helper.rb
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'devise'
require 'shoulda/matchers'
require 'factory_bot_rails'
require 'faker'
require 'support/authentication_helper'

# Initialize custom logger for test environment
custom_log_file = Rails.root.join('log', 'custom_test.log')
custom_logger = ActiveSupport::Logger.new(custom_log_file)
custom_logger.level = Logger::DEBUG
Rails.logger = ActiveSupport::TaggedLogging.new(custom_logger)

# Start logging
Rails.logger.info "Custom logger for test environment initialized"

RSpec.configure do |config|
  # Include FactoryBot syntax to simplify calls to factories
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include AuthenticationHelper, type: :request

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Setup custom logger before the suite runs
  config.before(:suite) do
    Rails.logger = ActiveSupport::TaggedLogging.new(custom_logger)
    Rails.logger.level = Logger::DEBUG
    Rails.logger.info "Starting test suite"
  end

  config.after(:suite) do
    Rails.logger.info "Test suite completed"
  end

  # Capture ActiveJob logs
  config.before(:each) do
    ActiveJob::Base.logger = Rails.logger
  end

  config.after(:each) do
    ActiveJob::Base.logger = nil
  end
end

# Configure Shoulda Matchers to use RSpec as the test framework and full matcher libraries for Rails
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

puts "Rails helper loaded"