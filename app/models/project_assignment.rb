# frozen_string_literal: true

class ProjectAssignment < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: ['To Do', 'In Progress', 'Done'] }
  validates :priority, presence: true

  def claimed?
    user_id.present?
  end
end
