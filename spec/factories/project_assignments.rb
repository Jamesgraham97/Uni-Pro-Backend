FactoryBot.define do
    factory :project_assignment do
      title { Faker::Lorem.sentence }
      description { Faker::Lorem.paragraph }
      status { 'To Do' }
      priority { 'High' }
      association :project
      association :user
    end
  end
  