
class Assignment < ApplicationRecord
  belongs_to :course_module, optional: true
  belongs_to :user, optional: true
  
  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :priority, presence: true
end
