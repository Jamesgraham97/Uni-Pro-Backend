# spec/jobs/recommendation_job_spec.rb

require 'rails_helper'

RSpec.describe RecommendationJob, type: :job do
  let!(:user) { create(:user) }
  let!(:project) { create(:project, team: create(:team), grade_weight: 90) }
  let!(:assignment1) { create(:assignment, user: user, title: 'Assignment 1', status: 'To Do', grade_weight: 80, priority: 'high', due_date: Date.today + 1.day) }
  let!(:assignment2) { create(:assignment, user: user, title: 'Assignment 2', status: 'In Progress', grade_weight: 50, priority: 'medium', due_date: Date.today + 9.days) }
  let!(:assignment3) { create(:assignment, user: user, title: 'Assignment 3', status: 'To Do', grade_weight: 90, priority: 'high', due_date: Date.today + 5.days) }
  let!(:project_assignment1) { create(:project_assignment, user: user, project: project, title: 'Project Assignment 1', status: 'To Do', priority: 'high') }
  let!(:project_assignment2) { create(:project_assignment, user: user, project: project, title: 'Project Assignment 2', status: 'In Progress', priority: 'low') }
  let!(:other_user) { create(:user) }

  it 'sends recommendations for tasks that meet the threshold' do
    expect {
      RecommendationJob.perform_now
    }.to change { Notification.where(user: user).count }.by(3) # Expecting notifications for three tasks of user
  end

  it 'does not send recommendations for tasks that do not meet the threshold' do
    allow_any_instance_of(RecommendationJob).to receive(:recommendation_threshold).and_return(15.0) # Set high threshold
    expect {
      RecommendationJob.perform_now
    }.to_not change { Notification.where(user: user).count }
  end

  it 'does not send recommendations for tasks of other users' do
    expect {
      RecommendationJob.perform_now
    }.to_not change { Notification.where(user: other_user).count }
  end
end
