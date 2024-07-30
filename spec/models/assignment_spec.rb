# spec/models/assignment_spec.rb
require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe 'associations' do
    it { should belong_to(:course_module).optional }
    it { should belong_to(:user).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:priority) }
  end

  describe 'valid assignment' do
    it 'has a valid factory' do
      expect(build(:assignment)).to be_valid
    end
  end

  describe 'invalid without a title' do
    it 'is invalid without a title' do
      assignment = build(:assignment, title: nil)
      expect(assignment).to_not be_valid
    end
  end

  describe 'invalid without a description' do
    it 'is invalid without a description' do
      assignment = build(:assignment, description: nil)
      expect(assignment).to_not be_valid
    end
  end

  describe 'invalid without a status' do
    it 'is invalid without a status' do
      assignment = build(:assignment, status: nil)
      expect(assignment).to_not be_valid
    end
  end

  describe 'invalid without a priority' do
    it 'is invalid without a priority' do
      assignment = build(:assignment, priority: nil)
      expect(assignment).to_not be_valid
    end
  end
end
