# frozen_string_literal: true

class DailySummaryJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      Rails.logger.info "Processing user #{user.id}"
      send_daily_summary(user)
    end
  end

  private

  def send_daily_summary(user)
    tasks_due_today = user.assignments.where(due_date: Date.today)
    high_priority_tasks = user.assignments.where(priority: 'high', status: ['To Do', 'In Progress'])
    tasks_due_soon = user.assignments.where(due_date: Date.tomorrow..3.days.from_now)

    Rails.logger.info "User #{user.id} - Initial tasks: Due today: #{tasks_due_today.size}, High priority: #{high_priority_tasks.size}, Due soon: #{tasks_due_soon.size}"

    user.teams.each do |team|
      tasks_due_today += team.projects.where(due_date: Date.today)
      tasks_due_soon += team.projects.where(due_date: Date.tomorrow..3.days.from_now)
      
      team.projects.each do |project|
        high_priority_tasks += project.project_assignments.where(priority: 'high', status: ['To Do', 'In Progress'])
      end
    end

    Rails.logger.info "User #{user.id} - Aggregated tasks: Due today: #{tasks_due_today.size}, High priority: #{high_priority_tasks.size}, Due soon: #{tasks_due_soon.size}"

    content = "Daily Summary:\n\n"
    content += "Tasks due today:\n"
    tasks_due_today.each { |task| content += "- #{task.respond_to?(:title) ? task.title : task.name}\n" }
    content += "\nHigh priority tasks:\n"
    high_priority_tasks.each { |task| content += "- #{task.respond_to?(:title) ? task.title : task.name}\n" }
    content += "\nTasks due soon:\n"
    tasks_due_soon.each { |task| content += "- #{task.respond_to?(:title) ? task.title : task.name}\n" }

    if tasks_due_today.any? || high_priority_tasks.any? || tasks_due_soon.any?
      Notification.create(user: user, content: content.strip, read: false, notification_type: 'daily_summary')
      Rails.logger.info "Notification created for user #{user.id}"
    else
      Rails.logger.info "No notification created for user #{user.id} - No tasks to notify"
    end
  end
end
