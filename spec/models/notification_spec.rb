# spec/models/notification_spec.rb
require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:friend_request).class_name('Friendship').optional }
    it { should belong_to(:team).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:notification_type) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:notification)).to be_valid
    end

    it 'can create a notification with a friend request' do
      expect(build(:notification, :with_friend_request)).to be_valid
    end

    it 'can create a notification with a team' do
      expect(build(:notification, :with_team)).to be_valid
    end
  end
end
