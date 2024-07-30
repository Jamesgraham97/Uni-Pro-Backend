FactoryBot.define do
    factory :jwt_denylist do
      jti { SecureRandom.uuid }
      exp { 1.week.from_now }
    end
  end
  