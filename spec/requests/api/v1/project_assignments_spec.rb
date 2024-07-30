require 'rails_helper'

RSpec.describe Api::V1::ProjectAssignmentsController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:project_assignment) { create(:project_assignment, project: project, user: nil) } # Ensure the assignment is unclaimed
  let(:auth_headers) { authenticated_header(user) }

  before do
    Rails.logger.debug "Auth headers: #{auth_headers.inspect}"
    Rails.logger.debug "User: #{user.inspect}"
    Rails.logger.debug "Project: #{project.inspect}"
  end

  describe 'GET /api/v1/teams/:team_id/projects/:project_id/project_assignments' do
    before do
      get api_v1_team_project_project_assignments_path(team_id: project.team_id, project_id: project.id), headers: auth_headers
      Rails.logger.debug "Request headers: #{request.headers.to_h}"
      Rails.logger.debug "Response status: #{response.status}"
      Rails.logger.debug "Response body: #{response.body}"
    end

    it 'returns project assignments' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/v1/teams/:team_id/projects/:project_id/project_assignments' do
    context 'when creating a project assignment' do
      before do
        post api_v1_team_project_project_assignments_path(team_id: project.team_id, project_id: project.id), 
             params: { project_assignment: { title: 'New Assignment', description: 'New Description', status: 'To Do', priority: 'High' } }, 
             headers: auth_headers
        Rails.logger.debug "Request headers: #{request.headers.to_h}"
        Rails.logger.debug "Response status: #{response.status}"
        Rails.logger.debug "Response body: #{response.body}"
      end

      it 'creates the project assignment' do
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PATCH /api/v1/teams/:team_id/projects/:project_id/project_assignments/:id/claim' do
    before do
      patch claim_api_v1_team_project_project_assignment_path(team_id: project.team_id, project_id: project.id, id: project_assignment.id), 
            headers: auth_headers
      Rails.logger.debug "Request headers: #{request.headers.to_h}"
      Rails.logger.debug "Response status: #{response.status}"
      Rails.logger.debug "Response body: #{response.body}"
    end

    it 'claims the project assignment' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /api/v1/teams/:team_id/projects/:project_id/project_assignments/:id/update_status' do
    before do
      patch update_status_api_v1_team_project_project_assignment_path(team_id: project.team_id, project_id: project.id, id: project_assignment.id), 
            params: { status: 'In Progress' }, 
            headers: auth_headers
      Rails.logger.debug "Request headers: #{request.headers.to_h}"
      Rails.logger.debug "Response status: #{response.status}"
      Rails.logger.debug "Response body: #{response.body}"
    end

    it 'updates the project assignment status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /api/v1/teams/:team_id/projects/:project_id/project_assignments/:id' do
    before do
      put api_v1_team_project_project_assignment_path(team_id: project.team_id, project_id: project.id, id: project_assignment.id), 
          params: { project_assignment: { title: 'Updated Title' } }, 
          headers: auth_headers
      Rails.logger.debug "Request headers: #{request.headers.to_h}"
      Rails.logger.debug "Response status: #{response.status}"
      Rails.logger.debug "Response body: #{response.body}"
    end

    it 'updates the project assignment' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /api/v1/teams/:team_id/projects/:project_id/project_assignments/:id' do
    before do
      delete api_v1_team_project_project_assignment_path(team_id: project.team_id, project_id: project.id, id: project_assignment.id), 
             headers: auth_headers
      Rails.logger.debug "Request headers: #{request.headers.to_h}"
      Rails.logger.debug "Response status: #{response.status}"
      Rails.logger.debug "Response body: #{response.body}"
    end

    it 'deletes the project assignment' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
