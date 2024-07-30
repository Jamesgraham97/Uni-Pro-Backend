class AddCourseModuleIdToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :course_module_id, :bigint
  end
end
