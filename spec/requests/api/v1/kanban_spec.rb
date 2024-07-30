require 'rails_helper'

RSpec.describe Api::V1::KanbanController, type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { authenticated_header(user) }
  
  before do
    create_list(:assignment, 3, user: user, status: 'To Do')
    create_list(:assignment, 2, user: user, status: 'In Progress')
    create_list(:assignment, 1, user: user, status: 'Done')

    create_list(:project_assignment, 3, user: user, status: 'To Do')
    create_list(:project_assignment, 2, user: user, status: 'In Progress')
    create_list(:project_assignment, 1, user: user, status: 'Done')
  end

  describe 'GET /api/v1/kanban' do
    before do
      get api_v1_kanban_path, headers: auth_headers
    end

    it 'returns the assignments and project assignments grouped by status' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      expect(json['todo_assignments'].length).to eq(3)
      expect(json['in_progress_assignments'].length).to eq(2)
      expect(json['done_assignments'].length).to eq(1)

      expect(json['todo_project_assignments'].length).to eq(3)
      expect(json['in_progress_project_assignments'].length).to eq(2)
      expect(json['done_project_assignments'].length).to eq(1)
    end
  end
end
