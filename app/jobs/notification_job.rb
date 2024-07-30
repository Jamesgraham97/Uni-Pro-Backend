# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :default

  def perform
    check_assignments
    check_project_assignments
  end

  private

  def check_assignments
    check_todo_assignments
    check_in_progress_assignments
    check_due_date_reminders
  end

  def check_project_assignments
    check_project_todo_assignments
    check_project_in_progress_assignments
    check_project_due_date_reminders
  end

  def check_todo_assignments
    assignments = Assignment.where('status = ? AND updated_at < ?', 'To Do', 3.days.ago)
    assignments.each do |assignment|
      send_notification(assignment.user,
                        "Your assignment '#{assignment.title}' has been in 'To Do' status for more than 3 days.")
    end
  end

  def check_in_progress_assignments
    assignments = Assignment.where('status = ? AND updated_at < ?', 'In Progress', 7.days.ago)
    assignments.each do |assignment|
      send_notification(assignment.user,
                        "Your assignment '#{assignment.title}' has been 'In Progress' for more than a week.")
    end
  end

  def check_due_date_reminders
    assignments = Assignment.where('due_date = ?', 2.days.from_now.to_date)
    assignments.each do |assignment|
      send_notification(assignment.user, "Your assignment '#{assignment.title}' is due in 2 days.")
    end
  end

  def check_project_todo_assignments
    project_assignments = ProjectAssignment.where('status = ? AND updated_at < ?', 'To Do', 3.days.ago)
    project_assignments.each do |assignment|
      send_notification(assignment.user,
                        "Your project assignment '#{assignment.title}' has been in 'To Do' status for more than 3 days.")
    end
  end

  def check_project_in_progress_assignments
    project_assignments = ProjectAssignment.where('status = ? AND updated_at < ?', 'In Progress', 7.days.ago)
    project_assignments.each do |assignment|
      send_notification(assignment.user,
                        "Your project assignment '#{assignment.title}' has been 'In Progress' for more than a week.")
    end
  end

  def check_project_due_date_reminders
    projects = Project.where('due_date = ?', 2.days.from_now.to_date)
    projects.each do |project|
      project_assignments = ProjectAssignment.where(project_id: project.id)
      project_assignments.each do |assignment|
        send_notification(assignment.user, "Your project '#{project.name}' is due in 2 days.")
      end
    end
  end

  def send_notification(user, content)
    Notification.create!(
      user:,
      content:,
      read: false,
      notification_type: 'assignment'
    )
  end
end
