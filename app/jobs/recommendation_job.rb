# frozen_string_literal: true

class RecommendationJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      Rails.logger.info "Processing user #{user.id}"
      recommend_tasks(user)
    end
  end

  private

  def recommend_tasks(user)
    tasks = user.assignments.where(status: ['To Do', 'In Progress']) + user.project_assignments.joins(:project).where(status: ['To Do', 'In Progress'])

    tasks.each do |task|
      score = calculate_score(task)
      Rails.logger.info "Task: #{task.title || task.name}, Score: #{score}, Threshold: #{recommendation_threshold}"
      send_recommendation(user, task) if score > recommendation_threshold
    end
  end

  def calculate_score(task)
    if task.is_a?(ProjectAssignment)
      grade_weight_score = task.project.grade_weight || 0
      due_date_score = [(30 - (task.project.due_date - Date.today).to_i), 0].max
    else
      grade_weight_score = task.grade_weight || 0
      due_date_score = [(30 - (task.due_date - Date.today).to_i), 0].max
    end

    priority_score = case task.priority
                     when 'low' then 1
                     when 'medium' then 2
                     when 'high' then 3
                     else 0
                     end
    status_score = case task.status
                   when 'To Do' then 10
                   when 'In Progress' then 5
                   else 0
                   end

    normalized_grade_weight_score = grade_weight_score / 100.0 * 4.0
    normalized_priority_score = priority_score / 3.0 * 3.0
    normalized_due_date_score = due_date_score / 30.0 * 2.0
    normalized_status_score = status_score / 10.0 * 1.0

    total_score = normalized_grade_weight_score + normalized_priority_score + normalized_due_date_score + normalized_status_score
    Rails.logger.info "Task: #{task.title || task.name}, Grade Weight Score: #{normalized_grade_weight_score}, Priority Score: #{normalized_priority_score}, Due Date Score: #{normalized_due_date_score}, Status Score: #{normalized_status_score}, Total Score: #{total_score}"
    total_score
  end

  def send_recommendation(user, task)
    Notification.create(user: user, content: "It's a good time to start working on '#{task.title || task.name}'.", read: false, notification_type: 'recommendation')
    Rails.logger.info "Notification created for user #{user.id} for task #{task.title || task.name}"
  end

  def recommendation_threshold
    5.0
  end
end
