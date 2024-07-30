require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { authenticated_header(user) }
  let!(:friend_request) { create(:friendship, user: user, friend: create(:user)) }
  let!(:team) { create(:team) }
  let!(:notification) { create(:notification, user: user, friend_request: friend_request, team: team) }

  describe 'GET /api/v1/notifications' do
    before do
      get api_v1_notifications_path, headers: auth_headers
    end

    it 'returns the list of notifications' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first['id']).to eq(notification.id)
    end
  end

  describe 'POST /api/v1/notifications/:id/respond_to_friend_request' do
    context 'when accepting the friend request' do
      before do
        post respond_to_friend_request_api_v1_notification_path(notification), params: { response: 'accept', friend_request_id: friend_request.id }, headers: auth_headers
      end

      it 'updates the friend request status to accepted' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('Friend request response recorded.')
        expect(friend_request.reload.status).to eq('accepted')
      end
    end

    context 'when declining the friend request' do
      before do
        post respond_to_friend_request_api_v1_notification_path(notification), params: { response: 'decline', friend_request_id: friend_request.id }, headers: auth_headers
      end

      it 'destroys the friend request' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('Friend request response recorded.')
        expect(Friendship.find_by(id: friend_request.id)).to be_nil
      end
    end
  end

  describe 'POST /api/v1/notifications/:id/respond_to_team_invite' do
    context 'when accepting the team invite' do
      before do
        post respond_to_team_invite_api_v1_notification_path(notification), params: { response: 'accept' }, headers: auth_headers
      end

      it 'creates a team member record and marks the notification as read' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('Team invitation accepted.')
        expect(TeamMember.exists?(user: user, team: team)).to be_truthy
        expect(notification.reload.read).to be_truthy
      end
    end

    context 'when declining the team invite' do
      before do
        post respond_to_team_invite_api_v1_notification_path(notification), params: { response: 'decline' }, headers: auth_headers
      end

      it 'marks the notification as read' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('Team invitation declined.')
        expect(notification.reload.read).to be_truthy
      end
    end

    context 'when providing an invalid response' do
      before do
        post respond_to_team_invite_api_v1_notification_path(notification), params: { response: 'invalid' }, headers: auth_headers
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('Invalid response.')
      end
    end
  end

  describe 'POST /api/v1/notifications/:id/mark_as_read' do
    before do
      post mark_as_read_api_v1_notification_path(notification), headers: auth_headers
    end

    it 'marks the notification as read' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('Notification marked as read.')
      expect(notification.reload.read).to be_truthy
    end
  end

  describe 'GET /test_notification' do
    before do
      get test_notification_path, headers: auth_headers
    end

    it 'creates a test notification' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('Test notification created.')
      expect(Notification.last.content).to eq('This is a test notification.')
    end
  end
end
