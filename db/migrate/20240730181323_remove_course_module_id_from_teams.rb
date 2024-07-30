class RemoveCourseModuleIdFromTeams < ActiveRecord::Migration[7.1]
  def change
    remove_column :teams, :course_module_id, :integer
  end
end
