# spec/models/team_spec.rb
require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'associations' do
    it { should have_many(:projects).dependent(:destroy) }
    it { should have_many(:team_members).dependent(:destroy) }
    it { should have_many(:users).through(:team_members) }
    it { should belong_to(:owner).class_name('User').with_foreign_key('owner_id') }
    it { should belong_to(:course_module) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:team)).to be_valid
    end
  end

  describe '#destroy_with_projects_and_assignments' do
    it 'destroys all projects and their assignments before destroying the team' do
      team = create(:team)
      project = create(:project, team: team)
      project_assignment = create(:project_assignment, project: project)

      expect { team.destroy_with_projects_and_assignments }.to change { Team.count }.by(-1)
                                                         .and change { Project.count }.by(-1)
                                                         .and change { ProjectAssignment.count }.by(-1)
    end
  end
end
