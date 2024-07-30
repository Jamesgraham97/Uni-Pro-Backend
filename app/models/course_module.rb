class CourseModule < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :teams
  belongs_to :user

  validates :name, presence: true
  validates :color, presence: true
end
