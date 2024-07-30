require 'rails_helper'

RSpec.describe Api::V1::ModulesController, type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { authenticated_header(user) }
  let!(:course_module) { create(:course_module, user: user) }

  describe 'GET /api/v1/modules' do
    before do
      get api_v1_modules_path, headers: auth_headers
    end

    it 'returns the list of modules' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first['id']).to eq(course_module.id)
    end
  end

  describe 'GET /api/v1/modules/:id' do
    before do
      get api_v1_module_path(course_module), headers: auth_headers
    end

    it 'returns the module' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(course_module.id)
    end
  end

  describe 'POST /api/v1/modules' do
    let(:valid_params) do
      { course_module: { name: 'New Module', description: 'New description', color: '#000000' } }
    end

    let(:invalid_params) do
      { course_module: { name: '', description: 'New description', color: '#000000' } }
    end

    context 'with valid parameters' do
      before do
        post api_v1_modules_path, params: valid_params, headers: auth_headers
      end

      it 'creates a new module' do
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['name']).to eq('New Module')
      end
    end

    context 'with invalid parameters' do
      before do
        post api_v1_modules_path, params: invalid_params, headers: auth_headers
      end

      it 'does not create a new module' do
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /api/v1/modules/:id' do
    let(:valid_params) do
      { course_module: { name: 'Updated Module' } }
    end

    let(:invalid_params) do
      { course_module: { name: '' } }
    end

    context 'with valid parameters' do
      before do
        put api_v1_module_path(course_module), params: valid_params, headers: auth_headers
      end

      it 'updates the module' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Updated Module')
      end
    end

    context 'with invalid parameters' do
      before do
        put api_v1_module_path(course_module), params: invalid_params, headers: auth_headers
      end

      it 'does not update the module' do
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE /api/v1/modules/:id' do
    before do
      delete api_v1_module_path(course_module), headers: auth_headers
    end

    it 'deletes the module' do
      expect(response).to have_http_status(:no_content)
      expect(CourseModule.find_by(id: course_module.id)).to be_nil
    end
  end
end
