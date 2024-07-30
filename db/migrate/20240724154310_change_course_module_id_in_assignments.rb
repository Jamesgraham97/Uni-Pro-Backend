# frozen_string_literal: true

class ChangeCourseModuleIdInAssignments < ActiveRecord::Migration[7.1]
  def change
    change_column_null :assignments, :course_module_id, true
  end
end
