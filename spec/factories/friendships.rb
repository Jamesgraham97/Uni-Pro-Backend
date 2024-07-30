# spec/factories/friendships.rb
FactoryBot.define do
    factory :friendship do
      association :user
      association :friend, factory: :user
      status { :pending }
    end
  end
  