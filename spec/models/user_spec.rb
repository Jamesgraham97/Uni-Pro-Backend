# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:course_modules).dependent(:destroy) }
    it { should have_many(:assignments) }
    it { should have_many(:team_members) }
    it { should have_many(:teams).through(:team_members) }
    it { should have_many(:projects).through(:teams) }
    it { should have_many(:project_assignments).through(:projects) }
    it { should have_one_attached(:profile_picture) }
    it { should have_many(:notifications).dependent(:destroy) }
    it { should have_many(:friendships) }
    it { should have_many(:friends).through(:friendships) }
    it { should have_many(:inverse_friendships).class_name('Friendship').with_foreign_key('friend_id') }
    it { should have_many(:inverse_friends).through(:inverse_friendships).source(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:display_name) }
    it { should validate_length_of(:display_name).is_at_most(50) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_confirmation_of(:password).on(:create) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe '#friendship_status' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    it 'returns not_friends if no friendship exists' do
      expect(user.friendship_status(friend)).to eq('not_friends')
    end

    it 'returns pending if a friendship is pending' do
      create(:friendship, user: user, friend: friend, status: 'pending')
      expect(user.friendship_status(friend)).to eq('pending')
    end

    it 'returns accepted if a friendship is accepted' do
      create(:friendship, user: user, friend: friend, status: 'accepted')
      expect(user.friendship_status(friend)).to eq('accepted')
    end
  end

  describe '#as_json' do
    let(:user) { create(:user) }

    it 'includes the profile_picture_url in the json output' do
      expect(user.as_json).to have_key('profile_picture_url')
    end
  end

  describe '#profile_picture_url' do
    let(:user) { create(:user) }

    it 'returns the url of the attached profile picture' do
      user.profile_picture.attach(io: File.open(Rails.root.join('spec', 'support', 'assets', 'test_image.png')), filename: 'test_image.png', content_type: 'image/png')
      expect(user.profile_picture_url).to be_present
    end

    it 'returns nil if no profile picture is attached' do
      expect(user.profile_picture_url).to be_nil
    end
  end
end
