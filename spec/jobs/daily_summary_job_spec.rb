# spec/jobs/daily_summary_job_spec.rb
require 'rails_helper'

RSpec.describe DailySummaryJob, type: :job do
  let!(:team) { create(:team) }
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user_not_in_team) { create(:user) }

  let!(:team_member1) { create(:team_member, team: team, user: user1) }
  let!(:team_member2) { create(:team_member, team: team, user: user2) }

  let!(:assignment_due_today_user1) { create(:assignment, user: user1, due_date: Date.today) }
  let!(:assignment_due_soon_user1) { create(:assignment, user: user1, due_date: Date.tomorrow) }
  let!(:high_priority_assignment_user1) { create(:assignment, user: user1, priority: 'high', status: 'To Do') }

  let!(:project_due_today) { create(:project, team: team, due_date: Date.today) }
  let!(:project_due_soon) { create(:project, team: team, due_date: Date.tomorrow) }

  let!(:high_priority_project_assignment) { create(:project_assignment, project: project_due_soon, priority: 'high', status: 'To Do') }

  before do
    Rails.logger.info "Test setup complete: Users: #{User.count}, Teams: #{Team.count}, Projects: #{Project.count}, Assignments: #{Assignment.count}, Project Assignments: #{ProjectAssignment.count}"
  end

  describe '#perform' do
    it 'sends a daily summary notification to each team member of the team' do
      Rails.logger.info "Starting test for notifications to team members"
      
      # Additional logging to verify setup
      Rails.logger.info "Users: #{User.count}"
      Rails.logger.info "Teams: #{Team.count}"
      Rails.logger.info "Projects: #{Project.count}"
      Rails.logger.info "Assignments: #{Assignment.count}"
      Rails.logger.info "Project Assignments: #{ProjectAssignment.count}"

      expect {
        DailySummaryJob.perform_now
      }.to change { Notification.count }.by(2) # Expecting notifications for both team members

      notifications = Notification.last(2)
      expect(notifications.map(&:user)).to contain_exactly(user1, user2)
      notifications.each do |notification|
        expect(notification.notification_type).to eq('daily_summary')
        expect(notification.content).to include("Tasks due today:")
        expect(notification.content).to include("High priority tasks:")
        expect(notification.content).to include("Tasks due soon:")
      end
    end

    it 'does not send a notification to users not in the team' do
      expect {
        DailySummaryJob.perform_now
      }.not_to change { Notification.where(user: user_not_in_team).count }
    end
  end
end
