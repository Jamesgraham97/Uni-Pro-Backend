module Api
  module V1
    class KanbanController < ApplicationController
      # Ensure user is authenticated before allowing access to controller actions
      before_action :authenticate_user!

      # List all assignments grouped by their status for the current user
      def index
        # Fetch assignments with status 'To Do' for the current user
        @todo_assignments = current_user.assignments.where(status: 'To Do')
        # Fetch assignments with status 'In Progress' for the current user
        @in_progress_assignments = current_user.assignments.where(status: 'In Progress')
        # Fetch assignments with status 'Done' for the current user
        @done_assignments = current_user.assignments.where(status: 'Done')

        # Fetch project assignments with status 'To Do' assigned to the current user
        @todo_project_assignments = ProjectAssignment.where(status: 'To Do', user_id: current_user.id)
        # Fetch project assignments with status 'In Progress' assigned to the current user
        @in_progress_project_assignments = ProjectAssignment.where(status: 'In Progress', user_id: current_user.id)
        # Fetch project assignments with status 'Done' assigned to the current user
        @done_project_assignments = ProjectAssignment.where(status: 'Done', user_id: current_user.id)

        # Render the assignments and project assignments as JSON, including associated user and course_module/project data
        render json: {
          todo_assignments: @todo_assignments.as_json(include: { user: { methods: :profile_picture_url }, course_module: { only: [:id, :color] } }),
          in_progress_assignments: @in_progress_assignments.as_json(include: { user: { methods: :profile_picture_url }, course_module: { only: [:id, :color] } }),
          done_assignments: @done_assignments.as_json(include: { user: { methods: :profile_picture_url }, course_module: { only: [:id, :color] } }),
          todo_project_assignments: @todo_project_assignments.as_json(include: { user: { methods: :profile_picture_url }, project: { include: { course_module: { only: [:id, :color] } } } }),
          in_progress_project_assignments: @in_progress_project_assignments.as_json(include: { user: { methods: :profile_picture_url }, project: { include: { course_module: { only: [:id, :color] } } } }),
          done_project_assignments: @done_project_assignments.as_json(include: { user: { methods: :profile_picture_url }, project: { include: { course_module: { only: [:id, :color] } } } })
        }
      end
    end
  end
end
