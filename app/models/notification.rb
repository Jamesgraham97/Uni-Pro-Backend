# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :friend_request, class_name: 'Friendship', optional: true
  belongs_to :team, optional: true

  validates :content, presence: true
  validates :notification_type, presence: true
end
