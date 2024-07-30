# spec/factories/projects.rb
FactoryBot.define do
    factory :project do
      name { "Sample project name" }
      description { "Sample project description" }
      given_date { Date.today }
      due_date { Date.today + 7.days }
      grade_weight { rand(1..100) }
      association :team
      module_id { create(:course_module).id }
    end
  end
  