# spec/factories/notifications.rb
FactoryBot.define do
    factory :notification do
      content { "Sample notification content" }
      notification_type { "info" }
      association :user
  
      trait :with_friend_request do
        association :friend_request, factory: :friendship
      end
  
      trait :with_team do
        association :team
      end
      trait :daily_summary do
        notification_type { "daily_summary" }
        content { "Daily Summary:\n\nTasks due today:\n- Sample Task\n\nHigh priority tasks:\n- High Priority Task\n\nTasks due soon:\n- Task due soon" }
      end
    end
  end
  