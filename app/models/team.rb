# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :users, through: :team_members
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  validates :name, presence: true

  def destroy_with_projects_and_assignments
    projects.each do |project|
      project.project_assignments.destroy_all
      project.destroy
    end
    destroy
  end
end
