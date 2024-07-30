# spec/models/friendship_spec.rb
require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:friend).class_name('User') }
  end

  describe 'validations' do
    it { should define_enum_for(:status).with_values([:pending, :accepted, :blocked]) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:friendship)).to be_valid
    end
  end
end
