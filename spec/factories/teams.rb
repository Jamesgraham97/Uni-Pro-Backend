# spec/factories/teams.rb
FactoryBot.define do
    factory :team do
      name { Faker::Team.name }
      association :owner, factory: :user
      association :course_module
    end
  end
  