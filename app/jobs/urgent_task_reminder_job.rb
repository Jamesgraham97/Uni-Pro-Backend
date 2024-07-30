# frozen_string_literal: true

class UrgentTaskReminderJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      send_urgent_task_reminder(user)
    end
  end

  private

  def send_urgent_task_reminder(user)
    urgent_tasks = user.assignments.where('due_date = ? OR (priority = ? AND due_date <= ?)', Date.tomorrow, 'high',
                                          1.day.from_now) + user.project_assignments.where('due_date = ? OR (priority = ? AND due_date <= ?)', Date.tomorrow,
                                                                                           'high', 1.day.from_now)

    return if urgent_tasks.empty?

    content = "Urgent Task Reminder:\n\n"
    urgent_tasks.each { |task| content += "- #{task.title} (due #{task.due_date})\n" }

    Notification.create(user:, content: content.strip, read: false, notification_type: 'urgent_task_reminder')
  end
end
