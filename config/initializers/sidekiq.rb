# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
  config.logger.level = Logger::DEBUG

  schedule_file = 'config/sidekiq_schedule.yml'
  if File.exist?(schedule_file)
    Sidekiq.logger.info("Loading schedule from #{schedule_file}")
    schedule = YAML.load_file(schedule_file)
    Sidekiq.logger.info("Loaded schedule: #{schedule.inspect}")

    if schedule.is_a?(Hash)
      Sidekiq.schedule = schedule
      Sidekiq::Scheduler.reload_schedule!
      Sidekiq.logger.info('Schedule reloaded successfully')
    else
      Sidekiq.logger.error("Invalid schedule format in #{schedule_file}")
    end
  else
    Sidekiq.logger.error("Schedule file not found: #{schedule_file}")
  end

  Sidekiq::Scheduler.enabled = true
  Sidekiq::Scheduler.dynamic = true
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end
