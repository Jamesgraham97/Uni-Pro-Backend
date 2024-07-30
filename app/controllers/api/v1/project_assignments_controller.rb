module Api
  module V1
    class ProjectAssignmentsController < ApplicationController
      # Ensure user is authenticated before allowing access to controller actions
      before_action :authenticate_user!
      # Set project before actions that require it
      before_action :set_project, only: %i[create index]
      # Set project assignment before actions that require it
      before_action :set_project_assignment, only: %i[claim update_status update destroy]

      # List all project assignments for a specific project
      def index
        Rails.logger.info 'Index action called'
        @project_assignments = @project.project_assignments.includes(:user)
        render json: @project_assignments.as_json(include: { user: { methods: :profile_picture_url } }), status: :ok
      end

      # Create a new project assignment
      def create
        Rails.logger.info("Create action called with params: #{params.inspect}")

        @project = Project.find(params[:project_id])
        @assignment = @project.project_assignments.new(project_assignment_params)

        if @assignment.save
          Rails.logger.info("Assignment created: #{@assignment.inspect}")
          render json: @assignment, status: :created
        else
          Rails.logger.info("Assignment creation failed: #{@assignment.errors.full_messages}")
          render json: @assignment.errors, status: :unprocessable_entity
        end
      end

      # Claim a project assignment for the current user
      def claim
        Rails.logger.info("Claim action called with params: #{params.inspect}")

        @assignment = ProjectAssignment.find(params[:id])
        if @assignment.claimed?
          Rails.logger.info("Assignment already claimed by user: #{@assignment.user_id}")
          render json: { status: 'Assignment already claimed' }, status: :forbidden
        else
          @assignment.update(user: current_user)
          if @assignment.save
            Rails.logger.info("Assignment claimed successfully: #{@assignment.inspect}")
            render json: { status: 'Assignment claimed' }, status: :ok
          else
            Rails.logger.info("Claiming assignment failed: #{@assignment.errors.full_messages}")
            render json: @assignment.errors, status: :unprocessable_entity
          end
        end
      end

      # Update the status of a project assignment
      def update_status
        Rails.logger.info 'Update status action called'
        if @project_assignment.update(status: params[:status])
          render json: @project_assignment, status: :ok
        else
          render json: @project_assignment.errors, status: :unprocessable_entity
        end
      end

      # Update an existing project assignment
      def update
        if @project_assignment.update(project_assignment_params)
          render json: @project_assignment, status: :ok
        else
          render json: @project_assignment.errors, status: :unprocessable_entity
        end
      end

      # Delete a project assignment
      def destroy
        @project_assignment.destroy
        head :no_content
      end

      private

      # Set project based on provided parameters
      def set_project
        Rails.logger.info 'Set project called'
        @project = Project.find(params[:project_id])
      end

      # Set project assignment based on provided parameters
      def set_project_assignment
        Rails.logger.info 'Set project assignment called'
        @project_assignment = ProjectAssignment.find(params[:id])
      end

      # Strong parameters to permit only allowed attributes for project assignment
      def project_assignment_params
        params.require(:project_assignment).permit(:title, :description, :status, :priority, :user_id)
      end
    end
  end
end