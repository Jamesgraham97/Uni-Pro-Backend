# spec/models/project_spec.rb
require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should belong_to(:team) }
    it { should belong_to(:course_module).class_name('CourseModule').with_foreign_key('module_id') }
    it { should have_many(:project_assignments) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:given_date) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:grade) }
    it { should validate_presence_of(:module_id) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:project)).to be_valid
    end
  end
end
