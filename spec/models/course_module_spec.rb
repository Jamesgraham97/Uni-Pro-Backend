require 'rails_helper'

RSpec.describe CourseModule, type: :model do
  describe 'associations' do
    it { should have_many(:assignments).dependent(:destroy) }
    it { should have_many(:teams) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:color) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:course_module)).to be_valid
    end
  end
end
