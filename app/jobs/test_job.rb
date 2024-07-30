# frozen_string_literal: true

class TestJob
  include Sidekiq::Job

  def perform
    puts 'TestJob is running'
  end
end
