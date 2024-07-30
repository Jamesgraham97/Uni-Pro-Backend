FactoryBot.define do
    factory :course_module do
      name { Faker::Educator.course_name }
      description { Faker::Lorem.paragraph }
      association :user
      color { Faker::Color.hex_color }
    end
  end
  