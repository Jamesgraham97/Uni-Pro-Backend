# app/models/project.rb
class Project < ApplicationRecord
  belongs_to :team
  has_many :project_assignments
  belongs_to :course_module, class_name: 'CourseModule', foreign_key: 'module_id'

  validates :name, :given_date, :due_date, :description, :module_id, :grade_weight, presence: true
  validates :grade_weight, numericality: { only_integer: true }
end
