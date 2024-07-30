require 'rails_helper'

RSpec.describe Api::V1::AssignmentsController, type: :request do
  let(:user) { create(:user) }
  let!(:course_module) { create(:course_module, user: user) } # Ensure course_module is created before assignment
  let(:assignment) { create(:assignment, course_module: course_module, user: user) }
  let(:auth_headers) { authenticated_header(user) }

  before do
    Rails.logger.debug "Auth headers: #{auth_headers.inspect}"
    Rails.logger.debug "User: #{user.inspect}"
    Rails.logger.debug "Course Module: #{course_module.inspect}"
  end

  describe 'GET /api/v1/assignments' do
    context 'when fetching assignments for the current user' do
      before do
        get api_v1_assignments_path, headers: auth_headers
        Rails.logger.debug "Request headers: #{request.headers.to_h}"
        Rails.logger.debug "Response status: #{response.status}"
        Rails.logger.debug "Response body: #{response.body}"
      end

      it 'returns assignments' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /api/v1/assignments/:id' do
    before do
      get api_v1_assignment_path(assignment.id), headers: auth_headers
      Rails.logger.debug "Request headers: #{request.headers.to_h}"
      Rails.logger.debug "Response status: #{response.status}"
      Rails.logger.debug "Response body: #{response.body}"
    end

    it 'returns the assignment' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/v1/assignments' do
    context 'when creating an assignment for a course module' do
      before do
        Rails.logger.debug "Creating assignment with course_module_id: #{course_module.id} and user_id: #{user.id}"
        post api_v1_assignments_path, params: { assignment: { title: 'Test Assignment', description: 'Test Description', due_date: Date.today, given_date: Date.today, status: 'To Do', priority: 'high', grade_weight: 10, course_module_id: course_module.id, user_id: user.id } }, headers: auth_headers
        Rails.logger.debug "Request headers: #{request.headers.to_h}"
        Rails.logger.debug "Response status: #{response.status}"
        Rails.logger.debug "Response body: #{response.body}"
      end

      it 'creates the assignment' do
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PUT /api/v1/assignments/:id' do
    before do
      put api_v1_assignment_path(assignment.id), params: { assignment: { title: 'Updated Title' } }, headers: auth_headers
      Rails.logger.debug "Request headers: #{request.headers.to_h}"
      Rails.logger.debug "Response status: #{response.status}"
      Rails.logger.debug "Response body: #{response.body}"
    end

    it 'updates the assignment' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /api/v1/assignments/:id' do
    before do
      delete api_v1_assignment_path(assignment.id), headers: auth_headers
      Rails.logger.debug "Request headers: #{request.headers.to_h}"
      Rails.logger.debug "Response status: #{response.status}"
      Rails.logger.debug "Response body: #{response.body}"
    end

    it 'deletes the assignment' do
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PATCH /api/v1/assignments/:id/update_status' do
    let(:assignment) { create(:assignment, course_module: course_module, user: user) } # Ensure assignment is created
    before do
      patch update_status_api_v1_assignment_path(assignment.id), params: { status: 'Completed' }, headers: auth_headers
      Rails.logger.debug "Request headers: #{request.headers.to_h}"
      Rails.logger.debug "Response status: #{response.status}"
      Rails.logger.debug "Response body: #{response.body}"
    end

    it 'updates the assignment status' do
      expect(response).to have_http_status(:ok)
    end
  end
end
