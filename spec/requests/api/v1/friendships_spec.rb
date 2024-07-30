require 'rails_helper'

RSpec.describe Api::V1::FriendshipsController, type: :request do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:auth_headers) { authenticated_header(user) }

  describe 'GET /api/v1/friendships' do
    let!(:friendship) { create(:friendship, user: user, friend: friend, status: 'accepted') }

    before do
      get api_v1_friendships_path, headers: auth_headers
    end

    it 'returns the list of friends' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first['id']).to eq(friend.id)
    end
  end

  describe 'POST /api/v1/friendships' do
    context 'when a friendship does not already exist' do
      before do
        post api_v1_friendships_path, params: { friendship: { friend_id: friend.id } }, headers: auth_headers
      end

      it 'creates a new friendship request' do
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('Friend request sent.')
      end
    end

    context 'when a friendship already exists' do
      let!(:existing_friendship) { create(:friendship, user: user, friend: friend, status: 'pending') }

      before do
        post api_v1_friendships_path, params: { friendship: { friend_id: friend.id } }, headers: auth_headers
      end

      it 'does not create a new friendship request' do
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('Friend request already sent or received.')
      end
    end
  end

  describe 'PUT /api/v1/friendships/:id' do
    let!(:friendship) { create(:friendship, user: user, friend: friend, status: 'pending') }

    context 'when accepting a friend request' do
      before do
        put api_v1_friendship_path(friendship), params: { status: 'accepted' }, headers: auth_headers
      end

      it 'updates the friendship status' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('Friendship updated.')
        expect(friendship.reload.status).to eq('accepted')
      end
    end

    context 'when blocking a friend request' do
      before do
        put api_v1_friendship_path(friendship), params: { status: 'blocked' }, headers: auth_headers
      end

      it 'updates the friendship status' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('Friendship updated.')
        expect(friendship.reload.status).to eq('blocked')
      end
    end
  end

  describe 'DELETE /api/v1/friendships/:id' do
    let!(:friendship) { create(:friendship, user: user, friend: friend, status: 'accepted') }

    before do
      delete api_v1_friendship_path(friendship), headers: auth_headers
    end

    it 'deletes the friendship' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('Friendship deleted.')
      expect(Friendship.find_by(id: friendship.id)).to be_nil
    end
  end

  describe 'GET /api/v1/friendships/status/:id' do
    let!(:friendship) { create(:friendship, user: user, friend: friend, status: 'pending') }

    before do
      get status_api_v1_friendship_path(friend), headers: auth_headers
    end

    it 'returns the friendship status' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('request_sent')
    end
  end
end
