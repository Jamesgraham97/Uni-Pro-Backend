# spec/models/project_assignment_spec.rb
require 'rails_helper'

RSpec.describe ProjectAssignment, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:user).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:priority) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:project_assignment)).to be_valid
    end
  end
end
