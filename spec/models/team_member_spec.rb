# spec/models/team_member_spec.rb
require 'rails_helper'

RSpec.describe TeamMember, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:team) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:team_member)).to be_valid
    end
  end
end
