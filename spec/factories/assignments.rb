# spec/factories/assignments.rb
FactoryBot.define do
    factory :assignment do
      title { Faker::Lorem.sentence }
      description { Faker::Lorem.paragraph }
      due_date { Date.today + 7.days }
      given_date { Date.today }
      status { 'To Do' }
      priority { 'High' }
      grade_weight { rand(1..100) }
      association :course_module
      association :user
    end
  end
  